//
//  CollectionPDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 05.03.21.
//

import SwiftUI

struct CollectionPDFView: View {
        
    @EnvironmentObject var ec : EnvironmentController
     
    @Binding var song: Song
    @Binding var songInGig: SongInGig
    @Binding var pageIndex: String
    
    @State var collection: Collection

    var body: some View {
        ZStack{
            PDFKitCampireView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $pageIndex, presentationModde: true)
            HStack{
                if chevronLeftIsVisible() {
                    Button(action: {backPage()}, label: {
                        Image(systemName: "chevron.left").font(.title2).padding()
                    })
                }
                Spacer()
                if chevronRightIsVisible(){
                    Button(action: {nextPage()}, label: {
                        Image(systemName: "chevron.right").font(.title2).padding()
                    })
                    
                }
            }
        }.gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width <= 0 && chevronRightIsVisible() {
                            nextPage()
                        }
                        if value.translation.width >= 0 && chevronLeftIsVisible(){
                            backPage()                        }
                    }))
        .onTapGesture {
            ec.song = song
            ec.pageIndexString = pageIndex
            ec.songInGig = songInGig
            ec.gig = songInGig.gig!
            ec.presentationModeGig = true
        }
    }
  
    func backPage() {
        
        if Int((song.startPage)!) ==  Int(pageIndex) {
            
            let currentSongPosition = songInGig.position
            //  let songsInGig = getArraySongInGig(gig.songsInGig!)
            
            collection.titelsInCollection.forEach{ songInGig in
                
                if songInGig.position < currentSongPosition  {
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
            let neuPageIndex = pageIndexInt - 1
            pageIndex = String(neuPageIndex)
        }
    }
    
    func nextPage() {
        
        if song.endPage != nil {
            
            if Int((song.endPage)!) == Int(pageIndex) { // TODO: Hir höte ein buck sein
                
                let currentSongPosition = songInGig.position
                //  let songsInGig = getArraySongInGig(gig.songsInGig!)
                
                var bool = true
                
                collection.titelsInCollection.forEach{ songInGig in
                    
                    if songInGig.position > currentSongPosition && bool {
                        song = songInGig.song!
                        self.songInGig = songInGig
                        pageIndex = (songInGig.song?.startPage)!
                        bool = false
                    }
                }
            }else {
                let pageIndexInt = Int(pageIndex)!
                let neuPageIndex = pageIndexInt + 1
                pageIndex = String(neuPageIndex)
            }
        } else {
            
            let currentSongPosition = songInGig.position
            
            var bool = true
            
            collection.titelsInCollection.forEach{ songInGig in
                
                if songInGig.position > currentSongPosition && bool {
                    song = songInGig.song!
                    self.songInGig = songInGig
                    pageIndex = (songInGig.song?.startPage)!
                    bool = false
                }
            }
        }
    }
    
    func chevronLeftIsVisible() -> Bool {
        
        var isVisible: Bool = true
        
        if  songInGig.position == 0 && pageIndex == collection.titels[0].startPage {
            isVisible  = false
        }
        return isVisible
    }
    
    func chevronRightIsVisible() -> Bool {
        
        var isVisible: Bool = true
        
        if songInGig.position + 1 == collection.titels.count && pageIndex == collection.titels.last!.endPage {
            isVisible  = false
        }
        return isVisible
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
