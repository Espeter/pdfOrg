//
//  AllTitelsLiestView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 08.03.21.
//

import SwiftUI

struct AllTitelsLiestView: View {
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    @State private var searchText: String = ""
    @Binding var selectedTitel: Song
    @Binding var pageIndex: String
 //   @Binding var segmentTitels : [String: [Song]]
    @Binding  var titels: Titles
     var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    @Binding var reload: Bool

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(.bottom, 15)
            
            if searchText == "" {
                
                ScrollViewReader { scroll in
                    HStack{
                        List(){
                            
                            let segmentTitels = titels.getSegmentTitles(by: alphabet, songs: songs)
                            
                            ForEach(alphabet, id: \.self){ char in
                                
                                if segmentTitels[char]!.count > 0 {
                                    Section(header: Text(char).id(char)) {
                                        ForEach(segmentTitels[char]!, id: \.self) { (song: Song) in
                                            
                                            Button(action: {setTitel(song: song)}, label: {
                                                VStack(alignment: .leading){
                                                    HStack{
                                                        Text(song.title ?? "error_no Titel")
                                                        if song.isFavorit {
                                                            Image(systemName: "star.fill").padding(.leading, 10)
                                                        }
                                                        if reload {
                                                            Text("")
                                                        } else {
                                                            Text("")
                                                        }
                                                    }
                                                    HStack{
                                                        Text(song.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
                                                        Spacer()
                                                        Text(song.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                                                    }.font(.footnote)
                                                }
                                            })
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
                            }.padding(.trailing, 10)
                        }
                    }
                }.padding(.top, -17)
            } else {
                List {
                    ForEach(titels.getSearchResult(searchTerms: searchText, songs: songs), id: \.self) { (song: Song) in
                        
                        Button(action: {setTitel(song: song)}, label: {
                            VStack(alignment: .leading){
                                HStack{
                                    Text(song.title ?? "error_no Titel")
                                    if song.isFavorit {
                                        Image(systemName: "star.fill").padding(.leading, 10)
                                    }
                                }
                                HStack{
                                    Text(song.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
                                    Spacer()
                                    Text(song.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                                }.font(.footnote)
                            }
                        })
                        
                    }
                }
            }
        }
    }
    func setTitel(song: Song) {
        selectedTitel = song
        pageIndex = song.startPage ?? "1"
    }
}
