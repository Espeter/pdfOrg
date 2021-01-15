//
//  AddSongPopoverView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct AddSongPopoverView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var book: Book
    @Binding var showingPopup: Bool
    
    @State private var title: String = ""
    @State private var startSide: String = ""
    @State private var author: String = ""
    
    var body: some View {
    
        VStack{
            HStack{
            Text("title: ")
            TextField("title of Song", text: $title)
            }
            HStack{
            Text("Page: ")
            TextField("1", text: $startSide)
            }
            HStack{
            Text("Author: ")
            TextField("name of Author", text: $author)
            }
            Button(action: {
                addSong()
                showingPopup = false
            }) {
                Text("Add").padding()
            }
        
        }.padding()
    }
    
    private func addSong() {
        
        let song: Song = Song(context: viewContext)
        
        song.id = UUID()
        song.title = title
        song.startPage = startSide 
        song.author = author
        
        book.addToSongs(song)
        
        saveContext()
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
