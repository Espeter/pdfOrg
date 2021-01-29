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

    @State var showingPopup = false
    @State var openFile = false

    
    var body: some View {
        VStack{
            HStack{
                
                Text("title").frame(maxWidth: .infinity, alignment: .leading)

                Text("page").frame(maxWidth: .infinity, alignment: .leading)

                Text("author").frame(maxWidth: .infinity/*, alignment: .leading*/)
                Button(action: {
                    deleteSongsAlert.toggle()
                }) {
                    Image(systemName: "trash")
                        //.padding()
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
                Button(action: {
                    openFile.toggle()
                }) {
                    Image(systemName: "square.and.arrow.down").padding()
                }
                Button(action: {
                    showingPopup.toggle()
                }) {
                    Image(systemName: "plus")
                        .popover(isPresented: self.$showingPopup) {
                            AddSongPopoverView(book: book, showingPopup: $showingPopup)
                        }
              //  }
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
