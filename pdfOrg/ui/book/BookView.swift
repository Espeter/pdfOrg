//
//  BookView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var book: Book
    @State var showingPopup = false
    @State var editMode = false
    
    var body: some View {
        
        HStack{
            VStack{
                BookInfoView(book: book, editMode: $editMode)
                    .padding()
                    .shadow( radius: 15, x: 3, y: 5)
                BookPDFView(book: book)
                    .padding()
                    .shadow( radius: 15, x: 3, y: 5)

            }
            BookSongCollectionView(book: book)
                .padding()
                .frame(width: 650)
                .shadow( radius: 15, x: 3, y: 5)

            
        }.background(Color(UIColor.systemBlue).opacity(0.05))
        .navigationBarTitle("\(book.title ?? "nil")")
        .navigationBarItems(trailing:
                HStack{
                    Button(action: {
                        if editMode {
                            saveContext()
                        }
                        editMode.toggle()
                        
                    }) {
                        if editMode {
                            Text("save").padding()
                        } else {
                            Text("edit").padding()
                        }
                        
                    }
                    Button(action: {
                        print("foo1")
                    }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                    Button(action: {
                        showingPopup.toggle()
                    }) {
                        Image(systemName: "plus").padding()
                            .popover(isPresented: self.$showingPopup) {
                                AddSongPopoverView(book: book, showingPopup: $showingPopup)
                            }
                    }
                }
        )
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
