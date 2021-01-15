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
    @State var openFile = false
    
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
            BookSongCollectionView(book: book, editMode: $editMode)
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
                        openFile.toggle()
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
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.text])
        { (res) in
            do {
                let fileUrl = try res.get()
                importSongs(url: fileUrl)
            }
            catch {
                print("error")
            }
            
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
    
    private func importSongs(url: URL) {
        
        var txt = String()
        
        do{
            guard url.startAccessingSecurityScopedResource() else {
                return
            }
            txt = try NSString(contentsOf: url, encoding: String.Encoding.ascii.rawValue) as String
            
        }  catch {
            print(error)
        }
        
        txt.enumerateLines(invoking: { (line, stop) -> () in
            let lineSplit = line.components(separatedBy:";")
            
            if lineSplit.count == 2 {
                addSong(name: lineSplit[0], startSide: lineSplit[1], author: nil)
            } else {
                addSong(name: lineSplit[0], startSide: lineSplit[1], author: lineSplit[2])
            }
        })
        url.stopAccessingSecurityScopedResource()
    }
    
    func addSong(name: String, startSide: String, author: String?) {
        
        let song: Song = Song(context: viewContext)
        
        song.id = UUID()
        song.title = name
        song.startPage = startSide
        song.author = author ?? "n.a."
        
        book.addToSongs(song)
        
        saveContext()
    }
}
