//
//  SelectGigSongView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 21.01.21.
//

import SwiftUI

struct SelectGigSongView: View {
    
    @State var songs: [Song]
    @Binding var gig: Gig
    @State var searchText: String = ""
    let alphabet : [String]
    @State var segmentSongs: [String: [Song]]
    @Binding var updateView: Bool
    
    @Binding var songIsSelectet: Bool
    @Binding var gigSongIsSelectet: Bool
    @Binding var songSelectet: Song?
    @Binding var pageIndex: String
    
    var body: some View {
        
        VStack{
            SearchBar(text: $searchText)
            if searchText != "" {
                List {
                    ForEach(songs, id: \.self) { (song: Song) in
                        if(compared(title: song.title!.lowercased(), author: song.author?.lowercased() ?? "", searchText: self.searchText.lowercased())){
                            SongRowInGigView(song: song, gig: $gig, updateView: $updateView, songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, songSelectet: $songSelectet, pageIndex: $pageIndex)
                       //     SongRowInGigView(song: song, gig: $gig, updateView: $updateView, )
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
                                            
                                            SongRowInGigView(song: song, gig: $gig, updateView: $updateView, songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, songSelectet: $songSelectet, pageIndex: $pageIndex)
                                        }
                                    }
                                }
                            }
                        }
                        VStack{
                            ScrollView{
                                ForEach(alphabet, id: \.self){ char in
                                    Button(char){
                                        scroll.scrollTo(char, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }.padding().background(Color(UIColor.white)).cornerRadius(15.0).shadow( radius: 15, x: 3, y: 5)
        
    }
    func compared(title: String, author: String , searchText: String) -> Bool {
        var bool = false
        
        var splitSearchText = searchText.components(separatedBy: " ")
        let splitTitle = title.components(separatedBy: " ")
        let splitAuthor = author.components(separatedBy: " ")
        let splitSearchTextCount = splitSearchText.count
        var comparedWords = 0
        
        splitTitle.forEach{ titleWord in
            
            splitSearchText.forEach{ search in
                
                if titleWord.contains(search) {
                    comparedWords = comparedWords + 1
                    splitSearchText.remove(at: splitSearchText.firstIndex(of: search)!)
                }
            }
        }
        
        splitAuthor.forEach{ authorWord in
            
            splitSearchText.forEach{ search in
                
                if authorWord.contains(search) {
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
}
