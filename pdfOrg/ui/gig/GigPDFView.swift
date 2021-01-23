//
//  GigPDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 23.01.21.
//

import SwiftUI

struct GigPDFView: View {
    
    @Binding var songIsSelectet: Bool
    @Binding var gigSongIsSelectet: Bool
    @Binding var song: Song?
    @Binding var pageIndex: String
    @Binding var songInGig: SongInGig?
    @State var gig: Gig
    
    var body: some View {
        VStack{
            if songIsSelectet {
                CampfirePDFView(song: umwantler(binding: $song, fallback: Song()), pageIndex: $pageIndex)
            } else if gigSongIsSelectet {
                HStack{
                    Button(action: {
                        print("back")
                        backPage()
                        print(pageIndex)
                    }) {
                        Image(systemName: "lessthan")
                    }
                    GigSongPDFView(pageIndex: $pageIndex, song: umwantler(binding: $song, fallback: Song()))
                    Button(action: {
                        nextPage()
                    }) {
                        Image(systemName: "greaterthan")
                    }
                }
            } else {
                Text("selekt Song")
            }
        }
        .frame(minWidth: 300,
               idealWidth: .infinity,
               maxWidth: .infinity,
               minHeight: 380.5,
               idealHeight: .infinity,
               maxHeight: .infinity)
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
        .shadow( radius: 15, x: 3, y: 5)
    }
    
    
    func backPage() {
        
        if Int((song?.startPage)!) ==  Int(pageIndex) {
            
            let currentSongPosition = songInGig?.position
            let songsInGig = getArraySongInGig(gig.songsInGig!)
            
            songsInGig.forEach{ songInGig in
                
                if songInGig.position < currentSongPosition!  {
                    song = songInGig.song
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
        
        if song?.endPage != nil {
            
            if Int((song?.endPage)!) == Int(pageIndex) { // TODO: Hir höte ein buck sein
                
                let currentSongPosition = songInGig?.position
                let songsInGig = getArraySongInGig(gig.songsInGig!)
                
                var bool = true
                
                songsInGig.forEach{ songInGig in
                    
                    if songInGig.position > currentSongPosition! && bool {
                        song = songInGig.song
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
            
            let currentSongPosition = songInGig?.position
            let songsInGig = getArraySongInGig(gig.songsInGig!)
            
            var bool = true
            
            songsInGig.forEach{ songInGig in
                
                if songInGig.position > currentSongPosition! && bool {
                    song = songInGig.song
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

