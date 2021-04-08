//
//  BookListOfSongsView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.03.21.
//

import SwiftUI

struct BookListOfSongsView: View {
    @EnvironmentObject var ec : EnvironmentController
    @EnvironmentObject var ecb : EnvironmentControllerBook

    @Environment(\.managedObjectContext) var viewContext

    @Binding var book: Book
    @Binding var updayitView: Bool
    @Binding var song: Song?
    
    @Binding var page: Int

    @Binding var editMode: Bool
    
    var body: some View {
        VStack{
            if updayitView {
                if editMode {
                    EditSongView(book: book, song: $song, page: $page, updayitView: $updayitView)
                } else {
                    Text("")
                }
            } else {
                if editMode {
                    EditSongView(book: book, song: $song, page: $page, updayitView: $updayitView)
                    
                } else {
                    Text("")
                }
            }
            if editMode {
                ScrollViewReader { scroll in
                    List() {
                       
                        ForEach(getArraySong(book.songs!)) { song in
                            
                            
                            Button(action: {
                                    self.song = song
                                page = Int(song.startPage ?? "1") ?? 1
                                ecb.titelName = song.title ?? "error_no titel"
                                ecb.startPage = song.startPage ?? "1"
                                ecb.endPage = song.endPage ?? song.startPage ?? "1"
                                ecb.label = song.author ?? ""
                                
                            }, label: {
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
                            })
                        }.onDelete(perform: delete)                    }
                }
            } else {
                ScrollViewReader { scroll in
                    List() {
                        if book.songs != nil {
                        ForEach(getArraySong(book.songs!)) { song in
                            Button(action: {
                                    self.song = song
                                page = Int(song.startPage ?? "1") ?? 1
                                ecb.titelName = song.title ?? "error_no titel"
                                ecb.startPage = song.startPage ?? "1"
                                ecb.endPage = song.endPage ?? song.startPage ?? "1"
                                ecb.label = song.author ?? ""
                                
                            }, label: {
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
                            })
                        }
                    }
                }
                }
            }

        }
    }
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map {getArraySong(book.songs!)[$0]}.forEach(viewContext.delete)
            updayitView.toggle()
         //   saveContext()
        }
    }

    
    private func saveContext(){
        do{
            try viewContext.save()
        }
        catch {
            let error = error as NSError
            fatalError("error addBook: \(error)")
        }
    }
    func getArraySong(_ snSet : NSSet) -> [Song] {
        
        let songs = snSet.allObjects as! [Song]
        
        let sortedSongs = songs.sorted {$0.title ?? "0" < $1.title ?? "0"}
        
        return sortedSongs
    }
    
}
