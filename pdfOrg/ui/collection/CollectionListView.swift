//
//  CollectionListView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 09.03.21.
//

import SwiftUI

struct CollectionListView: View {
    
    @Binding var titel: Song
    @Binding var titelInCollection: SongInGig
    @Binding var pageIndex: String
    
    @State var collection: Collection
    
    var body: some View {
        List() {
            
            ForEach(collection.titelsInCollection) { songInGig in
                
                if songInGig.song != nil {
                    
                    Button(action: {titelSelected(song: songInGig.song!,songInGigi: songInGig)}, label: {
                        HStack{
                            Text("\(songInGig.position).").font(.title3).padding(.trailing, 10)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text(songInGig.song!.title ?? "error_no Titel")
                                    if songInGig.song!.isFavorit {
                                        Image(systemName: "star.fill").padding(.leading, 10)
                                    }
                                }
                                HStack{
                                    Text(songInGig.song!.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
                                    Spacer()
                                    Text(songInGig.song!.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                                }.font(.footnote)
                            }
                        }
                    })
                }
            }
        }
    }
    private func titelSelected(song: Song, songInGigi: SongInGig) {
        titel = song
        titelInCollection = songInGigi
        pageIndex = song.startPage ?? "1"
    }
}
