//
//  LibraryView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI

struct LibraryView: View {
    
    @EnvironmentObject private var store: Store
    @EnvironmentObject var ec : EnvironmentController
    
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
    
    //  @State var presentationMode: Int = 0
    let presentationModes: [LocalizedStringKey] = ["LS_all" , "LS_label" ]
    let presentationModesImage = ["tag", "tag"]
    
    @State var allLabels: [String]
    @State var segmentBooksByLabel: [String: [Book]]
    @State var segmentBooks: [Int: [Book]]?
    
    @State var oldGeometryProxy: GeometryProxy?
    
    var body: some View {
        NavigationView(){
            //        ScrollView {
            VStack{
                
                if ec.presentationModeLibrary == 1 {
                    
                    ScrollView {
                        
                        ForEach(allLabels, id: \.self){ label in
                            
                            HStack{
                                if label == "-" || label == ""{
                                    Text("LS_no Label" as LocalizedStringKey)
                                        .font(.title)
                                        .padding()
                                        .padding(.bottom, -40)
                                        .multilineTextAlignment(.center)
                                } else {
                                    Text(label)
                                        .font(.title)
                                        .padding()
                                        .padding(.bottom, -40)
                                        .multilineTextAlignment(.center)
                                }
                                Spacer()
                            }
                            ScrollView(.horizontal) {
                                HStack(){
                                    
                                    ForEach(segmentBooksByLabel[label]!, id: \.self) { (book: Book) in
                                        
                                        CoverSheetView(book: book, popupIsActive: $popupIsActive)
                                    }
                                }.frame(height: 300).padding(.bottom, -20)
                            }
                            Divider()
                            Spacer()
                            if ec.updateGigInfoView {
                                Text("")
                            }
                        }
                    }
                } else {
                    GeometryReader { geometry in
                        ScrollView {
                            
                            ForEach(1 ..< (getBookRows(geometry: geometry) + 1 )) { i in
                                HStack{
                                    Image(systemName: "plus.circle").foregroundColor( Color(UIColor.systemBlue))
                                        
                                        .frame(width: 150, height: 215)
                                        .background(Color(UIColor.systemGray).opacity(0.1))
//                                        .border(Color.black)
//                                        .cornerRadius(15.0)
//                                        .border(Color.white)
                                        .cornerRadius(15.0)
                                        .shadow( radius: 8, x: 3, y: 5)
                                    
                                    
                                    ForEach(getSegmentBooks(geometry: geometry)[i] ?? [], id: \.self) { (book: Book) in
                                        
                                        CoverSheetView(book: book, popupIsActive: $popupIsActive)
                                    }
                                    if (geometry.size.width >= 100.0){
                                        Text("")
                                    } else {
                                        Text("")
                                    }
                                    
                                    
                                }.frame(height: 300)
                            }.frame(width: geometry.size.width)
                        }.frame(width: geometry.size.width)
                    }
                }
                
                
                
            }.background(Color(UIColor.systemGray6))
            //.background(Color(UIColor.systemBlue).opacity(0.05))
            .navigationBarTitle("LS_Library" as LocalizedStringKey)//, displayMode: .inline)
            .navigationBarItems(leading:
                                    
                                    Picker("", selection: $ec.presentationModeLibrary ){
                                        
                                        
                                        
                                        ForEach(0 ..< presentationModes.count) { i in
                                            HStack{
                                                //     Image(systemName: self.presentationModesImage[i])
                                                Text(self.presentationModes[i])
                                            }.tag(i)
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
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
                                                                Text("LS_Unlimited number of books" as LocalizedStringKey).foregroundColor(.black)
                                                                Button(action: {
                                                                    store.purcheseProduct(store.product(for: Store.Prodakt.unlimitedBooks.rawValue)!)
                                                                }, label: {
                                                                    Text("LS_Buy" as LocalizedStringKey).padding()
                                                                })
                                                            }
                                                            Button(action: {
                                                                store.restorePurchases()
                                                            }, label: {
                                                                Text("LS_Restore Purchases" as LocalizedStringKey).padding()
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
                Alert(title: Text("LS_too many books" as LocalizedStringKey),
                      message: Text("MUAHAHAHA"),
                      primaryButton: .cancel(Text("LS_back" as LocalizedStringKey)),
                      secondaryButton: .default(
                        Text("LS_Buy" as LocalizedStringKey),
                        action: {
                            
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
            //  }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func getSegmentBooks(geometry: GeometryProxy) -> [Int:[Book]] {
        //     if oldGeometryProxy?.size.width != geometry.size.width {
        var dictionary: [Int:[Book]] = [:]
        let maxBookWidth = getMaxBookWidth(geometry: geometry)
        let numberOfRows: Int = getBookRows(geometry: geometry)
        
        (1...numberOfRows).forEach{ i in
            dictionary[i] = []
        }
        
        var numberOfBooksInRow = 0
        var currentRow = 1
        
        getBooksAlphabetical().forEach{ book in
            
            if book.coverSheet != nil {
                if numberOfBooksInRow < maxBookWidth {
                    
                    dictionary[currentRow]?.append(book)
                    numberOfBooksInRow = numberOfBooksInRow + 1
                } else {
                    
                    currentRow = currentRow + 1
                    numberOfBooksInRow = 0
                    dictionary[currentRow]?.append(book)
                    numberOfBooksInRow = numberOfBooksInRow + 1
                }
            }
            
        }
        
        oldGeometryProxy = geometry
        return dictionary
        
        
    }
    
    func getBooksAlphabetical() -> [Book] {
        var booksAlphabetical: [Book] = []
        
        books.forEach{ book in
            booksAlphabetical.append(book)
        }
        
        booksAlphabetical.sort{
            $0.title! < $1.title!
        }
        return booksAlphabetical
    }
    
    
    func getMaxBookWidth(geometry: GeometryProxy) -> Int {
        var maxBookWidth: Int
        //    print("geometry.size.width: \(geometry.size.width)")
        
        if geometry.size.width != 0.0 {
            
            maxBookWidth = Int(geometry.size.width / 180)    // KP wie so nicht 200 ....
        } else {
            maxBookWidth = 7
        }
        
        return maxBookWidth
    }
    
    func getBookRows(geometry: GeometryProxy) -> Int {
        var rows: Float
        var rowsInt: Int
        
        rows = Float(books.count) / Float(getMaxBookWidth(geometry: geometry))
        rowsInt = Int(rows.rounded(.up))
        
        return rowsInt
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
