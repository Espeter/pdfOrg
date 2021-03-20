//
//  Book2View.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.03.21.
//

import SwiftUI

struct Book2View: View {
    
    @EnvironmentObject var ec : EnvironmentController
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var book: Book
    @State var editMode: Bool = false
    @State var newName: String = ""
    
    @State var page: Int = 1
    
    @State var delitBook: Bool = false
    @State var deleteSongsAlert: Bool = false
    @State var updayitView: Bool = false

    
    var body: some View {
        VStack(alignment: .leading){
            TitelCollectionVeiw(editMode: $editMode, titel: umwantler(binding: $book.title, fallback: "error_book.titel not faund"), name: $newName)
            
            GeometryReader { geometry in
                if geometry.size.width > geometry.size.height {
                    HStack {
                        Book2ViewView(book: book, page: $page)
                            .alert(isPresented: $deleteSongsAlert) {
                            Alert(title: Text("LS_delet oll Titels" as LocalizedStringKey),
                                  message: Text("LS_delete titels text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                  primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                              action: {
                                                                book.songs?.forEach{ song in
                                                                    viewContext.delete(song as! Song)
                                                                }
                                                                saveContext()
                                                                updayitView.toggle()
                                                              }),
                                  secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                            )
                        }
                        BookListOfSongsView(book: $book, updayitView: $updayitView)
                            .alert(isPresented: $delitBook) {
                            Alert(title: Text("LS_delete \"\(book.title!)\"" as LocalizedStringKey),
                                  message: Text("LS_delete Book text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                  primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                              action: {
                                                                ec.navigationLinkActive = false
                                                                viewContext.delete(book)
                                                                saveContext()
                                                              }),
                                  secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                            )
                        }
                    }
                }
                else {
                    VStack{
                        Book2ViewView(book: book, page: $page)
                            .alert(isPresented: $deleteSongsAlert) {
                            Alert(title: Text("LS_delet oll Titels" as LocalizedStringKey),
                                  message: Text("LS_delete titels text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                  primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                              action: {
                                                                book.songs?.forEach{ song in
                                                                    viewContext.delete(song as! Song)
                                                                }
                                                                saveContext()
                                                                updayitView.toggle()
                                                              }),
                                  secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                            )
                        }
                        BookListOfSongsView(book: $book, updayitView: $updayitView)
                            .alert(isPresented: $delitBook) {
                            Alert(title: Text("LS_delete \"\(book.title!)\"" as LocalizedStringKey),
                                  message: Text("LS_delete Book text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                  primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                              action: {
                                                                ec.navigationLinkActive = false
                                                                viewContext.delete(book)
                                                                saveContext()
                                                              }),
                                  secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                            )
                        }                    }
                }
            }
        }.padding(.top, -50)
        
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                
                Menu{
                    Button(action: {print("foo")}, label: {
                        Text("LS_edit" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"pencil")
                    })
                    Button(action: {print("foo")}, label: {
                        Text("LS_settings" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"gear")
                    })
                    Button(action: {print("foo")}, label: {
                        Text("LS_uplod contents" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"square.and.arrow.down")
                    })
                    Button(action: {print("foo")}, label: {
                        Text("LS_uplod contents" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"square.and.arrow.up")
                    })
                    Divider()
                    Button(action: {deleteSongsAlert.toggle()}, label: {
                        Text("LS_delit contents of Book" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"trash")
                    })
                    Button(action: {delitBook.toggle()}, label: {
                        Text("LS_delit Book" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"trash")
                    })
                }
                label: {
                    Image(systemName: "ellipsis.circle").padding()
                }
            }
        }
    }
    // Qelle: https://forums.swift.org/t/promoting-binding-value-to-binding-value/31055
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
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
