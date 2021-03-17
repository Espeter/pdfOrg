//
//  CollectionListView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 09.03.21.
//

import SwiftUI

struct CollectionListView: View {
    
    @FetchRequest(sortDescriptors: [])
    var books: FetchedResults<Book>
    
    @Binding var titel: Song
    @Binding var titelInCollection: SongInGig
    @Binding var pageIndex: String
    
    @Binding var collection: Collection
    
    @Binding var reload: Bool
    
    
//    @State private var nmae: String = "error_nmae not faund"
//    @State private var author: String = "error_author not faund"
//    @State private var boolTitel: String = "error_boolTitel not faund"
//    
//    @State private var is404: Bool = false
    
    var body: some View {
        List() {
            
            ForEach(collection.titelsInCollection) { songInGig in
                
                if songInGig.song != nil {
                    
                    Button(action: {titelSelected(song: songInGig.song!,songInGigi: songInGig)}, label: {
                        
                        
                        if songNotFaund(songInGig) {
                            HStack{
                                Text("\(songInGig.position).").font(.title3).padding(.trailing, 10)
                                
                                VStack(alignment: .leading){
                                    HStack{
                                        Text(songInGig.teitel ?? "error_no Titel")
//                                        if songInGig.song!.isFavorit {
//                                            Image(systemName: "star.fill").padding(.leading, 10)
//                                        }
                                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color(UIColor.systemYellow)).padding(.leading, 10)
                                       
                                        if reload {
                                            Text("")
                                        } else {
                                            Text("")
                                        }
                                    }
                                    HStack{
                                        Text("LS_This Teitel is not faund in Book" as LocalizedStringKey).foregroundColor(Color(UIColor.systemGray))
                                        Spacer()
                                        Text(songInGig.bookId ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                                    }.font(.footnote)
                                }
                            }
                        } else {
                            HStack{
                                Text("\(songInGig.position).").font(.title3).padding(.trailing, 10)
                                
                                VStack(alignment: .leading){
                                    HStack{
                                        Text(songInGig.song!.title ?? "error_no Titel")
                                        if songInGig.song!.isFavorit {
                                            Image(systemName: "star.fill").padding(.leading, 10)
                                        }
                                        if reload {
                                            Text("")
                                        } else {
                                            Text("")
                                        }
                                    }
                                    HStack{
                                        Text(songInGig.song!.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
                                        Spacer()
                                        Text(songInGig.song!.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                                    }.font(.footnote)
                                }
                            }
                        }
                        
                        
                        
//                        HStack{
//                            Text("\(songInGig.position).").font(.title3).padding(.trailing, 10)
//
//                            VStack(alignment: .leading){
//                                HStack{
//                                    Text(songInGig.song!.title ?? "error_no Titel")
//                                    if songInGig.song!.isFavorit {
//                                        Image(systemName: "star.fill").padding(.leading, 10)
//                                    }
//                                    if reload {
//                                        Text("")
//                                    } else {
//                                        Text("")
//                                    }
//                                }
//                                HStack{
//                                    Text(songInGig.song!.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
//                                    Spacer()
//                                    Text(songInGig.song!.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
//                                }.font(.footnote)
//                            }
//                        }
                        
                        
                        
                        
                        
                        
                        
                    })
                }
            }
//            .onAppear() {
//                if songNotFaund() {
//                    nmae = ""
//                    author = ""
//                    boolTitel = ""
//
//                    is404 = true
//                } else {
//                    nmae = songInGig.song!.title
//                    author = ""
//                    boolTitel = ""
//
//                    is404 = false
//                }
//            }
        }
    }
    private func songNotFaund(_ songInGig: SongInGig) -> Bool {
        
        var is404: Bool = false
        
        if songInGig.song!.book?.id == "supergeheimmesBuchDasNurIchKennenDarf42MahahahahahahaGeheim" {
            
            if songIsThereNow(songInGig) {
                is404 = false
            } else {
                is404 = true
            }
        }
        return is404
    }
    
    private func songIsThereNow(_ songInGig: SongInGig) -> Bool {
        
        let songIsThereNow =  collection.songIsCollection(songInGig: songInGig, books: books)
          
        return songIsThereNow
    }
    
    private func titelSelected(song: Song, songInGigi: SongInGig) {
        titel = song
        titelInCollection = songInGigi
        pageIndex = song.startPage ?? "1"
    }
}
