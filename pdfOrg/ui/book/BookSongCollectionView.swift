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
    
    var body: some View {
        VStack{
            HStack{
                
                Text("title")
                Spacer()
                Text("|")
                Spacer()
                Text("page")
                Spacer()
                Text("|")
                Spacer()
                Text("author")
                
            }.padding().background(Color(UIColor.systemGray6))
            
            List() {
                
                ForEach(getArraySong(book.songs!)) { song in
                    HStack{
                        Text("\(song.title ?? "nil")")
                        Spacer()
                        Text("\(song.startPage)")
                        Spacer()
                        Text("\(song.author ?? "nil")")
                    }
                }.onDelete(perform: deleteSong)
            }
        }
         .background(Color(UIColor.white))
        .cornerRadius(15.0)
    }
    
    func getArraySong(_ snSet : NSSet) -> [Song] {
        
        let songs = snSet.allObjects as! [Song]
        
        let sortedSongs = songs.sorted {$0.startPage < $1.startPage}
        
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
