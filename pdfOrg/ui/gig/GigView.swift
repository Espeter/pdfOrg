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
    @State var showingPopup: Bool = false
    @State var copyGigTitel: String = ""
    
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
                                        Button(action: {
                                            showingPopup.toggle()
                                        }) {
                                            Image(systemName: "doc.on.doc").popover(isPresented: self.$showingPopup) {
                                                VStack{
                                                   
                                                    
                                                    
                                                    Text("Copy Gig").foregroundColor(Color(UIColor.black)).padding()
                                                    Text("")
                                                    HStack{
                                                    Text("from: \(gig.title!)").foregroundColor(Color(UIColor.black))
                                                        Spacer()
                                                    }.frame( alignment: .leading)
                                                    Text("")
                                                    HStack{
                                                        
                                                        Text("target: ").foregroundColor(Color(UIColor.black))
                                                        TextField("copy Gig", text: $copyGigTitel)
                                                    }.frame( alignment: .leading)
                                                    
                                                    
                                                    Text("")
                                                    Button(action: {
                                                        showingPopup.toggle()
                                                        copyGig(titel: copyGigTitel)
                                                    }) {
                                                        Text("Copy ").foregroundColor(Color(UIColor.white)).padding().background(Color(UIColor.systemBlue)).cornerRadius(15.0).padding()
                                                    }
                                                }.padding().frame(width: 200, height: 300)
                                            }
                                        }
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
    
    func copyGig(titel: String) {
        
        let copyGig: Gig = Gig(context: viewContext)
        
        if titel == "" {
            copyGig.title = "\(gig.title!) copy"
        } else {
            copyGig.title = titel
        }
        
        
        copyGig.id = UUID()
        
        gig.songsInGig?.forEach { songInGig in
            
            let newSongInGig  = SongInGig(context: viewContext)
            newSongInGig.position = (songInGig as! SongInGig).position
            newSongInGig.song = (songInGig as! SongInGig).song
            
            copyGig.addToSongsInGig(newSongInGig)
        }
        
        saveContext()
        gig = copyGig
        
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
    
    private func saveContext() {
        do{
            try viewContext.save()
        }
        catch {
            let error = error as NSError
            fatalError("error addBook: \(error)")
        }
    }
}
