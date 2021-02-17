//
//  LibraryView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI

struct LibraryView: View {
    
    @EnvironmentObject private var store: Store
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
     var books: FetchedResults<Book>
    @FetchRequest(sortDescriptors: [])
    private var products: FetchedResults<Product>
    
    @State private var searchText = ""
    @State private var openFile = false
    
    @State private var popupIsActive = false
    //   @State private var currentBook: Book?
    
    @State private var navigationLinkActive = false
    @State var tooManyBooksAlert: Bool = false
    
    @State private var storeOpen: Bool = false
    
    var body: some View {
        NavigationView(){
            
            VStack{
                
                HStack{
                    Text("All")
                        .font(.title)
                        .padding()
                        .padding(.bottom, -40)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    HStack(){
                        ForEach(getArrayBook(books)) { book in
                            
                            CoverSheetView(/*navigationLinkActive: $navigationLinkActive, */book: book, popupIsActive: $popupIsActive/*, currentBook: $currentBook*/)
                        }
                        
                        //                       Rectangle()
                        RadialGradient(gradient: Gradient(colors: [Color.white, Color.white.opacity(0.2)]), center: .topLeading, startRadius: 2, endRadius: 180)
                            .frame(width: 151.2, height: 213.84)
                            
                            
                            //   .mask(Rectangle().fill(LinearGradient(Color.white, Color.blue)))
                            
                            .border(Color.white)
                            //  .border(Color.black)
                            .cornerRadius(15.0)
                        
                        //                            .shadow( radius: 15, x: 3, y: 5)
                        //                                            .shadow(color: Color.white, radius: 10, x: -10, y: -10)
                        //                                            .shadow(color: Color.black, radius: 10, x: 10, y: 10)
                        
                    }.frame(height: 300).padding(.bottom, -20)
                    
                }
                Divider()
                Spacer()
                Text("")
            }.background(Color(UIColor.systemBlue).opacity(0.12))
            //.background(Color(UIColor.systemGray5))//.opacity(0.151))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    HStack{
                                        //                                        SearchBar(text: $searchText).frame(width: 300)
                                        //                                        Image(systemName: "house").padding()
                                        //                                        Text("Genre")
                                        //                                        Text("|")
                                        //                                        Text("Autor")
                                    }
                                ,trailing:
                                    HStack{
                                        if !isBought(for: Store.Prodakt.unlimitedBooks.rawValue) {
                                            Button(action: {
                                                storeOpen.toggle()
                                                
                                            }) {
                                                Image(systemName: "cart")
                                                    .padding()
                                                    .popover(isPresented: $storeOpen) {
                                                        VStack{
                                                            HStack{
                                                                Text("Unlimited number of books").foregroundColor(.black)
                                                                Button(action: {
                                                                    store.purcheseProduct(store.product(for: Store.Prodakt.unlimitedBooks.rawValue)!)
                                                                }, label: {
                                                                    Text("Buy").padding()
                                                                })
                                                            }
                                                            Button(action: {
                                                                store.restorePurchases()
                                                            }, label: {
                                                                Text("Restore Purchases").padding()
                                                            })
                                                            
                                                        }.padding()
                                                    }
                                            }
                                        }
                                        Button(action: {
                                            if books.count >= 3 && !isBought(for: Store.Prodakt.unlimitedBooks.rawValue) {    //TODO: muss wie der was kosten
                 //                           if false {
                                                tooManyBooksAlert.toggle()
                                            } else {
                                                openFile.toggle()
                                            }
                                        }) {
                                            Image(systemName: "square.and.arrow.down").padding()
                                        }
                                    }
            )
            .alert(isPresented: $tooManyBooksAlert) {
                Alert(title: Text("too many books"),
                      message: Text("MUAHAHAHA"),
                      primaryButton: .cancel(Text("back")),
                      secondaryButton: .default(
                        Text("kaufen"),
                        action: {
                            print("fallo Lokio")
                            store.purcheseProduct(store.product(for: Store.Prodakt.unlimitedBooks.rawValue)!)
                            
                            
                            
                            
                        })
                )
                
                
                
            }
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf])
            { (res) in
                do {
                    let fileUrl = try res.get()
                    
                    addBook(url: fileUrl)
                }
                catch {
                    print("error")
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func isBought(for id: String) -> Bool {
        
        var isBought = false
        
        products.forEach { product in
            
            if product.id == id {
                isBought = true
            }
        }
        return isBought
    }
}
