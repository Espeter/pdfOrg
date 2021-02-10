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
    @State private var endPage: String = ""
    @Binding var currentBook: Int
    
    var body: some View {
        
        VStack{
            HStack{
                Text("Title: ")
                TextField("Title of Song", text: $title)
            }
            HStack{
                Text("Page: ")
                TextField(String(currentBook - (Int(book.pageOfset!) ?? 0)), text: $startSide)
                Text("-")
                TextField(String(currentBook - (Int(book.pageOfset!) ?? 0)), text: $endPage)
            }
            HStack{
                Text("Author: ")
                TextField("Name of Author", text: $author)
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
       
        
        if title != "" {
            song.title = title
        } else {
            song.title = "new Song"
        }
        
        if startSide != "" {
            song.startPage = startSide
        } else {
            song.startPage = String(currentBook - (Int(book.pageOfset!) ?? 0))
        }
        if endPage != "" {
            song.endPage = endPage
        } else {
            song.endPage = String(currentBook - (Int(book.pageOfset!) ?? 0))
        }
        
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
