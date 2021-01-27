//
//  CoverSheetView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI

struct CoverSheetView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var navigationLinkActive: Bool
    
    @State var book: Book
    @State private var showingPopup = false
    @Binding var popupIsActive: Bool
    @Binding var currentBook: Book?
    @State var selectedSong: Song?
    @State private var deleteBookAlert = false
    
    
    var body: some View {
        
        if book.coverSheet != nil {
            VStack{
                if currentBook != nil {
                    NavigationLink(destination: BookView(book: currentBook!, selectedSong: $selectedSong), isActive: $navigationLinkActive) { EmptyView() }.animation(nil)
                }
                Image(uiImage: UIImage(data: book.coverSheet!)!)
                    .resizable()
                    .frame(width: 151.2, height: 213.84)
                    .cornerRadius(15.0)
                    .shadow( radius: 15, x: 3, y: 5)
                    .padding()
                    .onTapGesture { //TODO: das ist noch nicht perfekt muss doch auch irgt wie ander gesehen
                        
                        if popupIsActive {
                            popupIsActive = false
                        } else {
                            showingPopup.toggle()
                            popupIsActive = true
                        }
                        
                    }
                    .popover(isPresented: self.$showingPopup) {
                        VStack{
                            Text("title: \(book.title ?? "n.a.")")
                            Text("version: \(book.version ?? "n.a.")")
                            Text("tonArt: \(book.tonArt ?? "n.a.")")
                            Text("\(String(book.songs!.count)) Songs")
                            Button(action: {
                                deleteBookAlert.toggle()
                            }) {
                                Image(systemName: "trash")
                                    .padding()
                                    .alert(isPresented: $deleteBookAlert) {
                                        Alert(title: Text("delet \"\(book.title!)\""),
                                              message: Text("Biest du dir sicher das diese Buch Löschen möchtest?\n es hat zur folge das alle \(book.songs?.count ?? 0) Lieder auch gelöscht sind"),
                                              primaryButton: .destructive(Text("delet"),
                                                                          action: {
                                                                            viewContext.delete(book)
                                                                            saveContext()
                                                                          }),
                                              secondaryButton: .cancel(Text("back"))
                                        )
                                    }
                            }
                            Button(action: {
                                currentBook = book
                                navigationLinkActive.toggle()
                                showingPopup = false
                            }) {
                                Image(systemName: "book").padding()
                            }
                        }.padding().frame(width: 200, height: 300).onDisappear{
                            popupIsActive = false
                        }
                    }
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
}

