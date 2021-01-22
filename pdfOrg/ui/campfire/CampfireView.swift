//
//  CampfireView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 16.01.21.
//

import SwiftUI

struct CampfireView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var songsFR: FetchedResults<Song>
    
    @State var songsArray: [Song]?
    @State var song: Song?
    @State var i: Int = 3
    @State var pageIndex: String?

    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]

    
    
    var body: some View {
        HStack{
            VStack{
            //    Text("Info")
                if song != nil {
                    CampfirePDFView(song: umwantler(binding: $song, fallback: Song()), pageIndex: umwantler(binding: $pageIndex, fallback: "1")).padding().frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 380.5, idealHeight: .infinity, maxHeight: .infinity)
               //     Text("\(song?.title ?? "papa")")
                    
                } else {
                    Text("selekt Song")
                       // .frame(width: 300, height: 380.5)
                        .frame(minWidth: 300, idealWidth: .infinity, maxWidth: .infinity, minHeight: 380.5, idealHeight: .infinity, maxHeight: .infinity)
                      //  .padding()
                        .background(Color(UIColor.white))
                        .cornerRadius(15.0)
                        .shadow( radius: 15, x: 3, y: 5)
                        .padding()
                        
                }
            }
            AllSongsView(songs: getArraySong(), song: $song, pageIndex: $pageIndex, alphabet: alphabet, segmentSongs: getSegmentSongs())
            .padding().padding(.leading, -20)
        }
        .background(Color(UIColor.systemBlue).opacity(0.05))
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
        dictionary["#"] = []
        
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

struct CampfireView_Previews: PreviewProvider {
    static var previews: some View {
        CampfireView()
    }
}
