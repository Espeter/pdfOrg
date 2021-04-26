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
    
    //   @State private var popupIsActive = false
    //   @State private var currentBook: Book?
    
 //   @State private var navigationLinkActive = false
    @State var tooManyBooksAlert: Bool = false
    
    @State private var storeOpen: Bool = false
    
    //  @State var presentationMode: Int = 0
    let presentationModes: [LocalizedStringKey] = ["LS_all" , "LS_label" ]
    let presentationModesImage = ["tag", "tag"]
    
    @State var allLabels: [String]
    @State var segmentBooksByLabel: [String: [Book]]
 //   @State var segmentBooks: [Int: [Book]]?
    
    @State var oldGeometryProxy: GeometryProxy?
    
    @Binding var collections: Collections
    
    var body: some View {
        
        NavigationView(){
            //        ScrollView {
            VStack{
                
                if ec.presentationModeLibrary == 1 {
                    
                    ScrollView {
                        
                        ForEach(allLabels, id: \.self){ label in
                            
                            HStack{
                                if label == ""{
                                    //   Text("LS_no Label" as LocalizedStringKey)
                                    //                                        .font(.title)
                                    //                                        .padding()
                                    //                                        .padding(.bottom, -40)
                                    //                                        .multilineTextAlignment(.center)
                                } else {
                                   
                                    
                                    Text(label)
                                        .font(.title)
                                        .padding()
                                        .padding(.bottom, -40)
                                        .multilineTextAlignment(.center)
                                        .onTapGesture {
                                            print("allLabels: \(allLabels)")
                                            print("segmentBooksByLabel: \(segmentBooksByLabel)")
                                            ec.updatLibrary.toggle()
                                        }
                                }
                                Spacer()
                            }
                            ScrollView(.horizontal) {
                                
                                HStack(){
                                    if /*label == "-" ||*/ label == "" {
                                        VStack{
                                            Image(systemName: "plus.circle")
                                                .foregroundColor( Color(UIColor.systemBlue))
                                                .font(.title)
                                                .frame(width: 151.2, height: 213.84)
                                                .background(Color(UIColor.systemGray).opacity(0.1))
                                                .cornerRadius(15.0)
                                                .shadow( radius: 8, x: 3, y: 5)
                                            
                                            Text("LS_add Book" as LocalizedStringKey)
                                                .foregroundColor( Color(UIColor.systemBlue))
                                                .frame(width: 151.2, height: 35)
                                        }.padding()
                                        .onTapGesture {
                                            if books.count >= 3 && !isBought(for: Store.Prodakt.unlimitedBooks.rawValue) {    //TODO: muss wie der was kosten
                                                //                           if false {
                                                tooManyBooksAlert.toggle()
                                           } else {
                                                openFile.toggle()
                                           }
                                        }
                                    }
                                    ForEach(segmentBooksByLabel[label]!, id: \.self) { (book: Book) in
                                        
                                        CoverSheetView(book: book, collections: $collections, allLabels: $allLabels, segmentBooksByLabel: $segmentBooksByLabel)
                                    }
                                }.frame(height: 300).padding(.bottom, -20)
                            }
                            Divider()
                            Spacer()
                            if ec.updateGigInfoView {
                                Text("")
                            } else {
                                Text("")
                            }
                        }
                    }
                } else {
                    GeometryReader { geometry in
                        VStack(alignment: .leading) {
                            ScrollView {
                                
                                if getBookRows(geometry: geometry) == 0 {
                                    HStack{
                                    VStack(alignment: .leading){
                                        Image(systemName: "plus.circle")
                                            .foregroundColor( Color(UIColor.systemBlue))
                                            .font(.title)
                                            .frame(width: 151.2, height: 213.84)
                                            .background(Color(UIColor.systemGray).opacity(0.1))
                                            .cornerRadius(15.0)
                                            .shadow( radius: 8, x: 3, y: 5)
                                        
                                        Text("LS_add Book" as LocalizedStringKey)
                                            .foregroundColor( Color(UIColor.systemBlue))
                                            .frame(width: 151.2, height: 35)
                                    }.padding()
                                    .onTapGesture {
                                        if books.count >= 3 && !isBought(for: Store.Prodakt.unlimitedBooks.rawValue) {    //TODO: muss wie der was kosten
                                            //                           if false {
                                            tooManyBooksAlert.toggle()
                                       } else {
                                            openFile.toggle()
                                        }
                                    }
                                        Spacer()
                                    }
                                }
                             
                           //     Text("\(getBookRows(geometry: geometry))")
                                ForEach(1 ..< (getBookRows(geometry: geometry) + 2 )) { i in    // TODO: wie so muss das eine 2 sein?
                                 //   Text("i: \(i)")
                                 //   Text("\(getBookRows(geometry: geometry))")
                                    HStack{
                                       
                                        if i == 1 {
                                            VStack{
                                                Image(systemName: "plus.circle")
                                                    .foregroundColor( Color(UIColor.systemBlue))
                                                    .font(.title)
                                                    .frame(width: 151.2, height: 213.84)
                                                    .background(Color(UIColor.systemGray).opacity(0.1))
                                                    .cornerRadius(15.0)
                                                    .shadow( radius: 8, x: 3, y: 5)
                                                   
                                                
                                                Text("LS_add Book" as LocalizedStringKey)
                                                    .foregroundColor( Color(UIColor.systemBlue))
                                                    .frame(width: 151.2, height: 35)
                                            } .padding(.leading, 15)
                                            .onTapGesture {
                                               if books.count >= 3 && !isBought(for: Store.Prodakt.unlimitedBooks.rawValue) {    //TODO: muss wie der was kosten
                                                    //                           if false {
                                                    tooManyBooksAlert.toggle()
                                                } else {
                                                    openFile.toggle()
                                                }
                                            }
                                        }
                                        ForEach(getSegmentBooks(geometry: geometry)[i] ?? [], id: \.self) { (book: Book) in
                                     
                                            CoverSheetView(book: book, collections: $collections, allLabels: $allLabels, segmentBooksByLabel: $segmentBooksByLabel)                                        }
                                        Spacer()
                                        if (geometry.size.width >= 100.0){
                                            Text("")
                                        } else {
                                            Text("")
                                        }
                                    }.frame( height: 300)
                                }.frame(width: geometry.size.width)
                            }
                        }.frame(width: geometry.size.width)
                    }
                }
                
            }.background(Color(UIColor.systemGray6))
            //.background(Color(UIColor.systemBlue).opacity(0.05))
            .navigationBarTitle("LS_Library" as LocalizedStringKey)//, displayMode: .inline)
          //  .navigationBarTitle(ec.navigationLinkActive ? "1" : "2")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isBought(for: Store.Prodakt.unlimitedBooks.rawValue) {

                        Menu{
                            Button(action: {
                                
                                let product = store.product(for: Store.Prodakt.unlimitedBooks.rawValue)
                                
                                if product != nil {
                                    store.purcheseProduct(product!)
                                } else {
                                    print("ERROR_no  store.product")
                                }
                                
                                
        
                            }, label: {
                            //    Text("LS_Unlimited number of books \(store.product(for: Store.Prodakt.unlimitedBooks.rawValue)!.price.description(withLocale: store.product(for: Store.Prodakt.unlimitedBooks.rawValue)!.priceLocale) + " " + String(store.product(for: Store.Prodakt.unlimitedBooks.rawValue)!.priceLocale.currencySymbol ?? ""))" as LocalizedStringKey)
                                Text("LS_Unlimited number of books \("")" as LocalizedStringKey)
                            })
                            Button(action: {
                                store.restorePurchases()
                            }, label: {
                                Text("LS_Restore Purchases" as LocalizedStringKey)
                            })
                        }
                        label: {
                            Image(systemName: "cart")
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    
                    Menu{
                        
                        Picker(selection: $ec.presentationModeLibrary, label: Text("")) {
                            HStack{
                                Text("LS_Alphabetical" as LocalizedStringKey)
                                Spacer()
                                Image(systemName:"textformat.abc")
                            }.tag(0)
                            HStack{
                                Text("LS_label" as LocalizedStringKey)
                                Spacer()
                                Image(systemName:"tag")
                            }.tag(1)
                        }
                        
                        
                        
//
//                        Button(action: {
//                            ec.presentationModeLibrary = 0
//                        }, label: {
//                            Text("LS_Alphabetical" as LocalizedStringKey)
//                            Spacer()
//                            Image(systemName:"textformat.abc")
//                        })
//                        Button(action: {
//                            ec.presentationModeLibrary = 1
//                        }, label: {
//                            Text("LS_label" as LocalizedStringKey)
//                            Spacer()
//                            Image(systemName:"tag")
//                        })
                    }
                    label: {
                        Text("LS_sort by" as LocalizedStringKey).padding()
                    }
                }
            }
            //            .navigationBarItems(leading:
            //                                    Picker("", selection: $ec.presentationModeLibrary ){
            //
            //                                        ForEach(0 ..< presentationModes.count) { i in
            //                                            HStack{
            //                                                //     Image(systemName: self.presentationModesImage[i])
            //                                                Text(self.presentationModes[i])
            //                                            }.tag(i)
            //                                        }
            //                                    }.pickerStyle(SegmentedPickerStyle())
            //                                ,trailing:
            //                                    HStack{
            //                                        if !isBought(for: Store.Prodakt.unlimitedBooks.rawValue) {
            //                                            Button(action: {
            //                                                storeOpen.toggle()
            //                                            }) {
            //                                                Image(systemName: "cart")
            //                                                    .padding()
            //                                                    .popover(isPresented: $storeOpen) {
            //                                                        VStack{
            //                                                            HStack{
            //                                                                Text("LS_Unlimited number of books" as LocalizedStringKey).foregroundColor(.black)
            //                                                                Button(action: {
            //                                                                    store.purcheseProduct(store.product(for: Store.Prodakt.unlimitedBooks.rawValue)!)
            //                                                                }, label: {
            //                                                                    Text("LS_Buy" as LocalizedStringKey).padding()
            //                                                                })
            //                                                            }
            //                                                            Button(action: {
            //                                                                store.restorePurchases()
            //                                                            }, label: {
            //                                                                Text("LS_Restore Purchases" as LocalizedStringKey).padding()
            //                                                            })
            //                                                        }.padding()
            //                                                    }
            //                                            }
            //                                        }
            //                                        Button(action: {
            //                                            if books.count >= 3 && !isBought(for: Store.Prodakt.unlimitedBooks.rawValue) {    //TODO: muss wie der was kosten
            //                                                //                           if false {
            //                                                tooManyBooksAlert.toggle()
            //                                            } else {
            //                                                openFile.toggle()
            //                                            }
            //                                        }) {
            //                                            Image(systemName: "square.and.arrow.down").padding()
            //                                        }
            //                                    }
            //            )
            .alert(isPresented: $tooManyBooksAlert) {
                Alert(title: Text("LS_too many books" as LocalizedStringKey),
                      message: Text("LS_too many books text" as LocalizedStringKey),
                      primaryButton: .cancel(Text("LS_back" as LocalizedStringKey)),
                      secondaryButton: .default(
                        Text("LS_Buy" as LocalizedStringKey),
                        action: {

                            let product = store.product(for: Store.Prodakt.unlimitedBooks.rawValue)
                                                        
                                                        if product != nil {
                                                            store.purcheseProduct(product!)
                                                        } else {
                                                            print("ERROR_no  store.product")
                                                        }                        })
                )
            }
//            .sheet(isPresented: $storeOpen) {
//                StoreView()
//            }
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf])
            { (res) in
                do {
                    let fileUrl = try res.get()
                    
                    addBook(url: fileUrl)
                    ec.updatLibrary.toggle()
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
            
            if currentRow == 1 && numberOfBooksInRow ==  0 {
                numberOfBooksInRow = 1
            }
            
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
  //      print("dictionary: \(dictionary)")
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
        
        rows = (Float(books.count) + 1) / Float(getMaxBookWidth(geometry: geometry))
        rowsInt = Int(rows.rounded(.up))
        
        if rowsInt == 0 {
            rowsInt = 1
        }
        print("rowsInt: \(rowsInt)")
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
        //   return false
    }
}
