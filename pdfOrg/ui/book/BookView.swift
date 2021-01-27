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
    @State var page: Int = 1
    @State var updateView: Bool = true
    @State var pageOfset: String = ""
    @State var infoPopup: Bool = false
    
    
    @Binding var selectedSong: Song?
    
    
    var body: some View {
        
        HStack{
            VStack{
//                BookInfoView(book: book, editMode: $editMode)
//                    .padding()
//                    .shadow( radius: 15, x: 3, y: 5)
                BookPDFView(book: book, song: $selectedSong, updateView: $updateView, page: $page)
                    .frame(idealHeight: .infinity)
                    .padding()
                    .shadow( radius: 15, x: 3, y: 5)
                
            }
            BookSongCollectionView(book: book, editMode: $editMode, page: $page, selectedSong: $selectedSong, updateView: $updateView)
                .padding()
                // .frame(width: 650)
                .shadow( radius: 15, x: 3, y: 5)
            
            
        }.background(Color(UIColor.systemBlue).opacity(0.05))
        .navigationBarTitle("\(book.title ?? "nil")")
        .navigationBarItems( leading:
                                HStack{
                                    Text("pageOfSet: ")
                                    TextField(book.pageOfset!, text: umwantler(binding: $book.pageOfset, fallback: "0"), onEditingChanged: {(changed) in
                                        if changed == false {
                                            saveContext()
                                        }
                                    })
                                    if updateView {
                                        Text("").frame(width: 0, height: 0)
                                    }
                                }.frame(width: 240)
        
                             ,
                             trailing:
                                HStack{
                                    Button(action: {
                                        infoPopup.toggle()
                                    }) {
                                        Image(systemName: "info.circle").popover(isPresented: self.$infoPopup ) {
                                            BookInfoView(book: book, editMode: $editMode, updateView: $updateView)
                                        }
                                    }
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
            //  txt = try NSString(contentsOf: url, encoding: String.Encoding.ascii.rawValue) as String
            txt = try NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) as String
        }  catch {
            print(error)
        }
        
        txt.enumerateLines(invoking: { (line, stop) -> () in
            let lineSplit = line.components(separatedBy:";")
            
            if lineSplit.count == 3 {
                addSong(name: lineSplit[0], startSide: lineSplit[1], endPage: lineSplit[2], author: nil)
            } else {
                addSong(name: lineSplit[0], startSide: lineSplit[1],endPage: lineSplit[2], author: lineSplit[3])
            }
        })
        url.stopAccessingSecurityScopedResource()
    }
    
    func addSong(name: String, startSide: String, endPage: String, author: String?) {
        
        let song: Song = Song(context: viewContext)
        
        song.id = UUID()
        song.isFavorit = false
        song.title = name
        song.startPage = startSide
        if endPage != ""{
            song.endPage = endPage
        } else {
            song.endPage = startSide
        }
        song.author = author ?? "n.a."
        
        book.addToSongs(song)
        
        saveContext()
    }
    
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
}
