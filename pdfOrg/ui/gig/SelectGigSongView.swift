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
    
    var body: some View {
        
        VStack{
            SearchBar(text: $searchText)
            if searchText != "" {
                List {
                    ForEach(songs, id: \.self) { (song: Song) in
                        if(compared(song.title!.lowercased(), searchText: self.searchText.lowercased())){
                            
                            SongRowInGigView(song: song, gig: $gig, updateView: $updateView)
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
                                            
                                            SongRowInGigView(song: song, gig: $gig, updateView: $updateView)
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
}
