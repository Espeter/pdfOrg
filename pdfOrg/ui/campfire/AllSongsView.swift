//
//  AllSongsView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 16.01.21.
//

import SwiftUI

struct AllSongsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    
    @Binding var song: Song?
    
    @State private var searchText = ""
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    
    var body: some View {
        VStack{
            SearchBar(text: $searchText)
            
            if searchText != "" {
                List {
                    ForEach(songs, id: \.self) { (song: Song) in
                        if(compared(song.title!.lowercased(), searchText: self.searchText.lowercased())){
                            
                            Button("\(song.title!)"){
                                self.song = song
                            }
                            
                        }
                    }
                }
            } else {
                
                ScrollViewReader { scroll in
                    
                    HStack{
                        List(){
                            
                            ForEach(alphabet, id: \.self){ char in
                                
                                if foo(char: char) {
                                    
                                    Section(header: Text(char).id(char)){
                                        
                                        ForEach(getArraySong(), id: \.self) { (song: Song) in
                                            if song.title?.lowercased().first == char.lowercased().first {
                                                Button("\(song.title!)"){
                                                    print("foo")
                                                    self.song = song
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                if getSpecialCharacterSongs().count != 0 {
                                    
                                    Section(header: Text("#").id("#")){
                                        
                                        ForEach(getSpecialCharacterSongs(), id: \.self) { (song: Song) in
                                            
                                            Button("\(song.title!)"){
                                                self.song = song
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        VStack{
                            
                            ForEach(alphabet, id: \.self){ char in
                                Button(char){
                                    scroll.scrollTo(char, anchor: .top)
                                }
                            }
                            Button("#"){
                                scroll.scrollTo("#", anchor: .top)
                            }
                        }
                        
                    }
                }
            }
        }.padding().background(Color(UIColor.white)).cornerRadius(15.0).shadow( radius: 15, x: 3, y: 5)
    }
    
    func compared(_ string: String, searchText: String) -> Bool {
        
        var bool = false
        
        var splitSearchText = searchText.components(separatedBy: " ")
        let splitString = string.components(separatedBy: " ")
        let splitSearchTextCount = splitSearchText.count
        var comparedWords = 0
        
        splitString.forEach{ word in
            
            splitSearchText.forEach{ search in
                
                if word.contains(search) {
                    comparedWords = comparedWords + 1
                    splitSearchText.remove(at: splitSearchText.firstIndex(of: search)!)
                }
            }
        }
        
        print("comparedWords: \(comparedWords)")
        print("splitSearchText.count: \(splitSearchText.count)")
        if splitSearchText.last == "" {
            comparedWords = comparedWords + 1
        }
        
        if comparedWords >= splitSearchTextCount {
            bool = true
        }
        return bool
    }
    
    func getSpecialCharacterSongs() -> [Song] {
        
        let songs = getArraySong()
        var songs123: [Song] = []
        
        songs.forEach { song in
            
            var bool = false
            
            alphabet.forEach { char in
                
                if song.title?.lowercased().first == char.lowercased().first {
                    
                    bool = true
                }
            }
            if bool == false {
                songs123.append(song)
            }
        }
        
        return songs123
    }
    
    func getArraySong() -> [Song] {
        var songsArray: [Song] = []
        
        songs.forEach{ song in
            songsArray.append(song)
        }
        
        songsArray.sort {
            $0.title! < $1.title!
        }
        return songsArray
    }
    
    func foo(char: String) -> Bool {
        
        var isIncluded = false
        
        let songs = getArraySong()
        
        songs.forEach{ song in
            
            if song.title?.lowercased().first == char.lowercased().first {
                isIncluded = true
            }
        }
        
        return isIncluded
    }
}
