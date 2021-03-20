//
//  CoverSheetView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI

struct CoverSheetView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var ec : EnvironmentController
    
 //   @Binding var navigationLinkActive: Bool
    
    @State var book: Book
    @State private var showingPopup = false
    @Binding var popupIsActive: Bool
  //  @Binding var currentBook: Book?
    @State var selectedSong: Song?
    @State private var deleteBookAlert = false
    @State var updateView: Bool = false
    
    
    
    var body: some View {
        
        if book.coverSheet != nil {
            VStack{
                if ec.currentBook != nil {
                  //  NavigationLink(destination: BookView(book: ec.currentBook!, updateView: updateView, selectedSong: $selectedSong), isActive: $ec.navigationLinkActive) { EmptyView() }.animation(nil)
                    NavigationLink(destination: Book2View(book: ec.currentBook!), isActive: $ec.navigationLinkActive) { EmptyView() }.animation(nil)
                    
                 
                }
                ZStack(alignment: .topTrailing) {
                Image(uiImage: UIImage(data: book.coverSheet!)!)
                    .resizable()
                    .frame(width: getWidth(), height: getHeight())
                    .onTapGesture {
//                        print(ec.currentBook?.title ?? "nil")
//                        print("fooooo143")
                        ec.currentBook = book
                        ec.navigationLinkActive.toggle()
                    }
                    .popover(isPresented: self.$showingPopup) {
                        VStack{
                            Text("LS_title".lowercased() + " : \(book.title ?? "n.a.")")
                            Text("Version: \(book.version ?? "n.a.")")
                            Text("Label: \(book.label ?? "")")
                            Text("\(String(book.songs!.count)) Songs")
                            Button(action: {
                                deleteBookAlert.toggle()
                            }) {
                                Image(systemName: "trash")
                                    .padding()
                                    .alert(isPresented: $deleteBookAlert) {
                                        Alert(title: Text("delete \"\(book.title!)\""),
                                              message: Text("Bist du dir sicher, dass du diese Buch Löschen möchtest?\n es hat zur Folge das alle \(book.songs?.count ?? 0) Lieder gelöscht sind"),
                                              primaryButton: .destructive(Text("delete"),
                                                                          action: {
                                                                            viewContext.delete(book)
                                                                            saveContext()
                                                                          }),
                                              secondaryButton: .cancel(Text("back"))
                                        )
                                    }
                            }
                            Button(action: {
                                ec.currentBook = book
                                ec.navigationLinkActive.toggle()
                                showingPopup = false
                            }) {
                                Image(systemName: "book").padding()
                            }
                        }.padding().frame(width: 200, height: 300).onDisappear{
                            popupIsActive = false
                        }
                    }
                    .cornerRadius(15.0)
                    .shadow( radius: 8, x: 3, y: 5)
//                    .shadow(color: Color.white, radius: 10, x: -10, y: -10)
//                    .shadow(color: Color.black, radius: 10, x: 10, y: 10)

                    .padding()
                    .onLongPressGesture { //TODO: das ist noch nicht perfekt muss doch auch irgt wie ander gesehen
                        if popupIsActive {
                            popupIsActive = false
                        } else {
                            showingPopup.toggle()
                            popupIsActive = true
                        }
                    }
                    
                   
//                    Button(action: {
//                        showingPopup.toggle()
//                    }) {
//                        Image(systemName:"info.circle").padding().padding()//.foregroundColor(Color(UIColor.systemGray))
//                    }
                    }
            }
        }
    }
    private func getWidth() -> CGFloat? {
        var width: CGFloat?
        if book.isLandscape == 1 {
            width = 213.84
        } else {
            width = 151.2
        }
        return width
    }

    private func getHeight() -> CGFloat? {
        var height: CGFloat?
        if book.isLandscape == 1 {
            height = 151.2
        } else {
            height = 213.84
        }
        return height
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

