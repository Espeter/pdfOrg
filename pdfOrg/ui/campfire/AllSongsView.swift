//
//  AllSongsView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 16.01.21.
//

import SwiftUI

struct AllSongsView: View {
    
    
    @State var songs: [Song]
    @Binding var song: Song?
    @Binding var pageIndex: String?
    
    
    @State private var searchText = ""
    let alphabet : [String]
    
    @State var segmentSongs: [String: [Song]]
    
    
    var body: some View {
        VStack{
            SearchBar(text: $searchText)
            
            if searchText != "" {
                List {
                    ForEach(songs, id: \.self) { (song: Song) in
                        if(compared(song.title!.lowercased(), searchText: self.searchText.lowercased())){
                            
                            
                            Button(action: {
                                self.song = song
                                pageIndex = song.startPage
                            }) {
                                HStack{
                                Text("\(song.title!)")
                                    if song.isFavorit {
                                        Spacer()
                                        Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray))
                                    }
                                }
                            }
                            
                            
//                            Button("\(song.title!)"){
//                                self.song = song
//                                pageIndex = song.startPage
//                            }
                        }
                    }
                }
            } else {
                
                ScrollViewReader { scroll in
                    
                    HStack{
                        List(){
                            
                            ForEach(alphabet, id: \.self){ char in
                                
                                if segmentSongs[char]!.count > 0 {
                                    Section(header: Text(char).id(char)) {
                                        ForEach(segmentSongs[char]!, id: \.self) { (song: Song) in
//                                            Button("\(song.title!)"){
//                                                print("foo")
//                                                self.song = song
//                                                pageIndex = song.startPage
//                                            }
                                            Button(action: {
                                                self.song = song
                                                pageIndex = song.startPage
                                            }) {
                                                HStack{
                                                Text("\(song.title!)")
                                                    if song.isFavorit {
                                                        Spacer()
                                                        Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray))
                                                    }
                                                }
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
                        }
                        
                    }
                }
            }
        }.padding().background(Color(UIColor.white)).cornerRadius(15.0).shadow( radius: 15, x: 3, y: 5)
    }
    
    //     func setSongsArray() -> [Song] {
    //        print("ich war hier")
    //        let x = getArraySong()
    //
    //        self.songsArray = x
    //        return x
    //
    //    }
    
    
    func compared(_ string: String, searchText: String) -> Bool {
        print("2")
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
        print("3")
        //  let songs = songsArray ?? setSongsArray()
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
    
    //    func getArraySong() -> [Song] {
    //        print("4")
    //        var songsArray: [Song] = []
    //
    //        songs.forEach{ song in
    //            songsArray.append(song)
    //        }
    //
    //        songsArray.sort {
    //            $0.title! < $1.title!
    //        }
    //        return songsArray
    //    }
    
    func foo(char: String) -> Bool {
        print("5")
        var isIncluded = false
        
        //     let songs = songsArray ?? setSongsArray()
        
        songs.forEach{ song in
            
            if song.title?.lowercased().first == char.lowercased().first {
                isIncluded = true
            }
        }
        return isIncluded
    }
    
    func getSegmentSongs() -> [String: [Song]] {
        print("getSegmentSongs()")
        var dictionary: [String: [Song]] = [:]
        
        alphabet.forEach{ char in
            dictionary[char] = []
        }
        dictionary["#"] = []
        
        songs.forEach{ song in
            let firstLetter = song.title?.first?.lowercased()
            
            if (dictionary[firstLetter!] != nil) {
                dictionary[firstLetter!]?.append(song)
            } else {
                dictionary["#"]?.append(song)
            }
        }
        segmentSongs = dictionary
        return dictionary
    }
}
