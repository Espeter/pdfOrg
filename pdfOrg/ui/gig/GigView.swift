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
    
    @State var showingSelectGigView: Bool = false
    @State var showingAddGigSongView: Bool = false
    
    @State var gig: Gig?
    @State var song: Song?
    
    @State var updateView: Bool = true
    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    
    var body: some View {
        
        NavigationView{
           
                HStack{
                    if gig != nil {
                    if showingAddGigSongView {
                        VStack{
                            GigInfoView(gig: umwantler(binding: $gig, fallback: Gig()), updateView: $updateView).padding()
                            Text("selekt Song")
                                // .frame(width: 300, height: 380.5)
                                .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 380.5, idealHeight: .infinity, maxHeight: .infinity)
                                //  .padding()
                                .background(Color(UIColor.white))
                                .cornerRadius(15.0)
                                .shadow( radius: 15, x: 3, y: 5)
                                .padding()
                        }
                        SelectGigSongView(songs: getArraySong(), gig: umwantler(binding: $gig, fallback: Gig()), alphabet: alphabet, segmentSongs: getSegmentSongs(), updateView: $updateView).padding()
                        
                    } else {
                        Text("selekt Song")
                            // .frame(width: 300, height: 380.5)
                            .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 380.5, idealHeight: .infinity, maxHeight: .infinity)
                            //  .padding()
                            .background(Color(UIColor.white))
                            .cornerRadius(15.0)
                            .shadow( radius: 15, x: 3, y: 5)
                            .padding()
                        GigInfoView(gig: umwantler(binding: $gig, fallback: Gig()), updateView: $updateView).padding()
                    }
                
            } else {
                VStack{
                    Text("selekt gig")
                }
            }}
            .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading:
                                        HStack{
                                            Text("Gig: ")
                                            Button(action: {
                                                showingSelectGigView.toggle()
                                            }) {
                                                Text("\(gig?.title ?? "selector Gig")")
                                                    .popover(isPresented: self.$showingSelectGigView) {
                                                        SelectGigView(gig: $gig, showingPopup: $showingSelectGigView)
                                                    }
                                            }
                                        }
                                    ,trailing:
                                        HStack{
                                            Button(action: {
                                                showingAddGigSongView.toggle()
                                            }) {
                                                Image(systemName: "plus")
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
        print("1")
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

struct GigView_Previews: PreviewProvider {
    static var previews: some View {
        GigView()
    }
}
