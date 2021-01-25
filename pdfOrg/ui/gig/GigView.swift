//
//  GigView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 15.01.21.
//

import SwiftUI

struct GigView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var songsFR: FetchedResults<Song>
    
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    
    @State var showingSelectGigView: Bool = false
    @State var showingAddGigSongView: Bool = false
    
    @State var gig: Gig
    @State var song: Song?
    @State var songInGig: SongInGig?
    
    @State var updateView: Bool = true
    
    @State var songIsSelectet: Bool = false
    @State var gigSongIsSelectet: Bool = false
    
    @State var pageIndex: String = "1"
    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    
    var body: some View {
        
        NavigationView{
            
            HStack{
            
                    if showingAddGigSongView {
                        VStack{
                            //      GigInfoView(gig: umwantler(binding: $gig, fallback: Gig()), updateView: $updateView)
                            GigInfoView(gig: $gig, updateView: $updateView, songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, songInGig: $songInGig, pageIndex: $pageIndex, song: $song)
                                .padding()
                            GigPDFView(songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, song: $song, pageIndex: $pageIndex, songInGig: $songInGig, gig: $gig)
                                .padding()
                                .padding(.top, -20)
                        }
                        SelectGigSongView(songs: getArraySong(), gig:  $gig, alphabet: alphabet, segmentSongs: getSegmentSongs(), updateView: $updateView, songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, songSelectet: $song, pageIndex: $pageIndex)
                            .padding()
                            .padding(.leading, -20)
                        
                    } else {
                        GigPDFView(songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, song: $song, pageIndex: $pageIndex, songInGig: $songInGig, gig:  $gig).padding()
                        //     GigInfoView(gig: umwantler(binding: $gig, fallback: Gig()), updateView: $updateView)
                        GigInfoView(gig: $gig, updateView: $updateView, songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, songInGig: $songInGig, pageIndex: $pageIndex, song: $song)
                            .padding()
                            .padding(.leading, -20)
                    }
                    
                 }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading:
                                        HStack{
                                            Text("Gig: ")
                                            Button(action: {
                                                showingSelectGigView.toggle()
                                            }) {
                                                Text("\(gig.title ?? "selector Gig")")
                                                    .popover(isPresented: self.$showingSelectGigView) {
                                                        SelectGigView(gig: $gig, showingPopup: $showingSelectGigView)
                                                    }
                                            }
                                        }
                                    ,trailing:
                                        HStack{
                                            if gig.title != "Favorits" {
                                            Button(action: {
                                                showingAddGigSongView.toggle()
                                            }) {
                                                Image(systemName: "plus")
                                            }
                                            }
                                        }
                )
                .background(Color(UIColor.systemBlue).opacity(0.05))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    
    

    
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
    
    func getArraySong() -> [Song] {
        var songsArray: [Song] = []
        
        songsFR.forEach{ song in
            songsArray.append(song)
        }
        
        songsArray.sort {
            $0.title! < $1.title!
        }
        return songsArray
    }
    
    func getSegmentSongs() -> [String: [Song]] {
        print("getSegmentSongs()")
        var dictionary: [String: [Song]] = [:]
        
        alphabet.forEach{ char in
            dictionary[char] = []
        }
        // dictionary["#"] = []
        
        getArraySong().forEach{ song in
            let firstLetter = song.title?.first?.lowercased()
            
            if (dictionary[firstLetter!] != nil) {
                dictionary[firstLetter!]?.append(song)
            } else {
                dictionary["#"]?.append(song)
            }
        }
        return dictionary
    }
}
