//
//  BookListOfSongsView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.03.21.
//

import SwiftUI

struct BookListOfSongsView: View {
    
    @Binding var book: Book
    @Binding var updayitView: Bool
    
    var body: some View {
        VStack{
            if updayitView{
                Text("")
            } else {
                Text("")
            }
            ScrollViewReader { scroll in
                List() {
                    ForEach(getArraySong(book.songs!)) { song in
                        VStack{
                            HStack{
                                Text(song.title ?? "error_no titel")
                                if song.isFavorit{
                                    Image(systemName: "star.fill").padding(.leading, 10)
                                }
                                Spacer()
                                Text(song.startPage ?? "error_no startPage").padding(.trailing, 20)
                            }
                            HStack{
                                Text(song.author ?? "").foregroundColor(Color(UIColor.systemGray))
                                Spacer()
                            }.font(.footnote)
                        }
                    }
                }
            }
        }
    }
    
    func getArraySong(_ snSet : NSSet) -> [Song] {
        
        let songs = snSet.allObjects as! [Song]
        
        let sortedSongs = songs.sorted {$0.title ?? "0" < $1.title ?? "0"}
        
        return sortedSongs
    }
}
