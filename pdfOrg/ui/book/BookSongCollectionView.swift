//
//  BookSongCollectionView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookSongCollectionView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var book: Book
    @Binding var editMode: Bool
    @Binding var page: Int
    @Binding var selectedSong: Song?
    @Binding var updateView: Bool
    @State var deleteSongsAlert: Bool = false


    
    var body: some View {
        VStack{
            HStack{
                
                Text("title").frame(maxWidth: .infinity, alignment: .leading)

                Text("page").frame(maxWidth: .infinity, alignment: .leading)

                Text("author").frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    deleteSongsAlert.toggle()
                }) {
                    Image(systemName: "trash")
                        .padding()
                        .alert(isPresented: $deleteSongsAlert) {
                        Alert(title: Text("delet all Songs"),
                              message: Text("bist du dir sicher das du alle \(book.songs?.count ?? 0) Lieder löschen möchtest?"),
                              primaryButton: .destructive(Text("delet"),
                                                          action: {
                                                            getArraySong(book.songs!).forEach { song in
                                                                viewContext.delete(song)
                                                            }
                                                            saveContext()
                                                          }),
                              secondaryButton: .cancel(Text("back"))
                        )
                    }
                }
            }.padding().background(Color(UIColor.systemGray6))
            
            List() {
                
                ForEach(getArraySong(book.songs!)) { song in
                    SongRowView(song: song, editMode: $editMode, page: $page, selectedSong: $selectedSong, updateView: $updateView)
                }.onDelete(perform: deleteSong)
            }
        }
         .background(Color(UIColor.white))
        .cornerRadius(15.0)
    }
    
    func getArraySong(_ snSet : NSSet) -> [Song] {
        
        let songs = snSet.allObjects as! [Song]
        
        let sortedSongs = songs.sorted {$0.title ?? "0" < $1.title ?? "0"}
        
        return sortedSongs
    }
    
    private func deleteSong(offsets: IndexSet) {
        withAnimation {
            offsets.map {getArraySong(book.songs!)[$0]}.forEach(viewContext.delete)
            saveContext()
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
}
