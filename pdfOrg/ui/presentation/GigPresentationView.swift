//
//  GigPresentationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 23.01.21.
//

import SwiftUI

struct GigPresentationView: View {
    
    @EnvironmentObject var ec : EnvironmentController
    
    @State var song: Song
    @State var pageIndex: String
    @State var navigationBarHidden = true
    @State var songInGig: SongInGig?
    @State var gig: Gig
    @State var isLandscape: Bool = true

    
    var body: some View {
        NavigationView(){
            ZStack(alignment: .topTrailing){
                PDFPresentationView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $pageIndex, isLandscape: $isLandscape)
               // PDFKitCampirePresentationView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $pageIndex, presentationModde: true)
                    .navigationBarTitle("\(song.title!)", displayMode: .inline)
                    .navigationBarItems(leading:
                                            HStack{
                                                Button(action: {
                                                    ec.presentationModeGig = false
                                                }) {
                                                    HStack{
                                                        Image(systemName: "lessthan")
                                                        Text("Back")
                                                    }
                                                }
                                            }
                    )
                    .navigationBarHidden(navigationBarHidden)
                    .onTapGesture {
                        navigationBarHidden.toggle()
                    }
                Button(action: {
                    ec.presentationModeGig = false
                }) {
                    Image(systemName:"multiply").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                }
            }
            .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.width <= 0 {
                                nextPage()
                            }
                            if value.translation.width >= 0 {
                                backPage()                        }
                        }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func visiblePages() -> Int {
        
        var visiblePages: Int
        
        if isLandscape {
            visiblePages = 2
        } else {
            visiblePages = 1
        }
        return visiblePages
    }
    
    func backPage() {
        
        if Int((song.startPage)!) ==  Int(pageIndex) {
            
            let currentSongPosition = songInGig?.position
            let songsInGig = getArraySongInGig(gig.songsInGig!)
            
            songsInGig.forEach{ songInGig in
                
                if songInGig.position < currentSongPosition!  {
                    song = songInGig.song!
                    self.songInGig = songInGig
                    if songInGig.song?.endPage != nil {
                        pageIndex = (songInGig.song?.endPage)!
                    } else {
                        pageIndex = (songInGig.song?.startPage)!
                    }
                }
            }
        } else {
            let pageIndexInt = Int(pageIndex)!
            let neuPageIndex = pageIndexInt - visiblePages()
            pageIndex = String(neuPageIndex)
        }
    }
    
    func nextPage() {
        
        if song.endPage != nil {
            
            if Int((song.endPage)!) == (Int(pageIndex)! - 1 + visiblePages()) { // TODO: Hir höte ein buck sein 🙈 das muss getestet werden!!!!!
                
                let currentSongPosition = songInGig?.position
                let songsInGig = getArraySongInGig(gig.songsInGig!)
                
                var bool = true
                
                songsInGig.forEach{ songInGig in
                    
                    if songInGig.position > currentSongPosition! && bool {
                        song = songInGig.song!
                        self.songInGig = songInGig
                        pageIndex = (songInGig.song?.startPage)!
                        bool = false
                    }
                }
            }else {
                let pageIndexInt = Int(pageIndex)!
                let neuPageIndex = pageIndexInt + visiblePages()
                pageIndex = String(neuPageIndex)
            }
        } else {
            
            let currentSongPosition = songInGig?.position
            let songsInGig = getArraySongInGig(gig.songsInGig!)
            
            var bool = true
            
            songsInGig.forEach{ songInGig in
                
                if songInGig.position > currentSongPosition! && bool {
                    song = songInGig.song!
                    self.songInGig = songInGig
                    pageIndex = (songInGig.song?.startPage)!
                    bool = false
                }
            }
        }
    }
    
    func getArraySongInGig(_ snSet : NSSet) -> [SongInGig] {
        var songsInGig = snSet.allObjects as! [SongInGig]
        
        songsInGig.sort {
            //    $0.position > $1.position
            $0.position < $1.position
        }
        
        return songsInGig
    }
    
    
    // Qelle: https://forums.swift.org/t/promoting-binding-value-to-binding-value/31055
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
}
