//
//  CollectionNavigationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 26.02.21.
//

import SwiftUI

struct CollectionNavigationView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    
    @FetchRequest(sortDescriptors: [])
    var books: FetchedResults<Book>
    
    @State var collections: Collections
    @Environment(\.managedObjectContext) private var viewContext
    @State var apdaytLokalView: Bool = true
    
    @State var addingCollection: Bool = false
    
    @State var faworitenssssisActive: Bool = true
    @State var allTitelsView: Bool = true
    @State var impotCollection: Bool = false
    
//    @State var allNonExistentBooks: [String]?
    @State var error: (Int,[String])?
    @State var errorText1 = ""
    @State var errorText: LocalizedStringKey = ""
    @State var bookAlert: Bool = false
    
    @State var infoIsVisible: Bool = false
    
    var body: some View {
        
        NavigationView{
            VStack{
                List(){
                    
                    Button(action: {addingCollection.toggle()}) {
                        HStack{
                            Image(systemName: "plus")
                                .foregroundColor(Color(UIColor.systemBlue))
                            Text("LS_New Collection" as LocalizedStringKey)
                        }
                    }.sheet(isPresented: $addingCollection) {
                        AddCollectionView(isActive: $addingCollection, collections: $collections).environment(\.managedObjectContext, viewContext)
                    }
                    
                    Button(action: {impotCollection.toggle()}) {
                        HStack{
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(Color(UIColor.systemBlue))
                            Text("Import Collection from .txt")
                            Spacer()
                            Image(systemName: "info.circle").foregroundColor(Color(UIColor.systemBlue))
                                .onTapGesture {
                                    infoIsVisible.toggle()
                                }
                        }
                    }.sheet(isPresented: $infoIsVisible) {
                        InfoImportCollectionView(isVisibel: $infoIsVisible)
                    }
         
                    Divider()
                    if Titles(songs: songs).array.count > 0 {
                    NavigationLink(destination: AllTitelsView(tilels: Titles(songs: songs), selectedTitel: Titles(songs: songs).array[0], collections: $collections) ,isActive: $allTitelsView) {
                        
                        Image(systemName: "list.bullet")
                            .foregroundColor(allTitelsView ? Color(UIColor.white) : Color(UIColor.systemBlue))
                        
                        Text("LS_All Titels" as LocalizedStringKey)
                    }
                    }
                    let faworitenGig = collections.get(collection: "Favorites")
                    
                    if faworitenGig.songsInGig!.count > 0 {
                    
                    NavigationLink( destination: CollectionView(collection: Collection(gig: faworitenGig), collections: $collections, faworitenssssisActive: $faworitenssssisActive, titel: Collection(gig: faworitenGig).titels[0], titelInCollection: Collection(gig: faworitenGig).titelsInCollection[0]) , isActive: $faworitenssssisActive) {
                        
                        Image(systemName: "star.fill")
                            .foregroundColor( Color(UIColor.systemBlue))//faworitenssssisActive ? Color(UIColor.yellow) : Color(UIColor.systemBlue))
                        Text("Faworiten")
                    }
                    }
                    Divider()
                    
                    ForEach(collections.array) { gig in
                        
            //            if Collection(gig: gig).titels.count > 0 && gig.title != "Favorites" {
                        if Collection(gig: gig).titels.count > 0 {
                        if gig.title != "Favorites" {
                            NavigationLink(destination: CollectionView(collection: Collection(gig: gig), collections: $collections, faworitenssssisActive: $faworitenssssisActive, titel: Collection(gig: gig).titels[0], titelInCollection: Collection(gig: gig).titelsInCollection[0])) {
                                
                                Text("\(gig.title ?? "error_no Title found")")
                            }
                        }
                        } else {
                            NavigationLink(destination:  Text("no song")) {
                                
                                Text("\(gig.title ?? "error_no Title found")")
                            }
                           
                        }
                        
                        
                    }
                }
            }.navigationBarTitle("LS_Collections" as LocalizedStringKey, displayMode: .inline)
        }
        .fileImporter(isPresented: $impotCollection, allowedContentTypes: [.text])
        { (res) in
            do {
                let fileUrl = try res.get()
               
              //  allNonExistentBooks = collections.importCollection(url: fileUrl, books: books)
                
                error = collections.importCollection(url: fileUrl, books: books)
                
                if error != nil {
                    errorText1 = ""
                    errorText = ""
                    
                    if error?.0 == 1 {
                        errorText1 = (error?.1[0])!
                    } else if error?.0 == 2 {
                        errorText = "LS_error Text import \(getnotExistingBooks(allNonExistentBooks: error?.1))" as LocalizedStringKey
                    } else if error?.0 == 3 {
                        errorText = "LS_Thes Books dasent exist: \(getnotExistingBooks(allNonExistentBooks: error?.1))" as LocalizedStringKey
                    }
                    
                    
                    bookAlert = true
                } else {
                    print("Import erfolkreich =)")
                }
                
            }
            catch {
                print("error_impot Collection")
            }
        }
        .alert(isPresented: $bookAlert) {
            
            Alert(title: Text("LS_error when loading the collection" as LocalizedStringKey),
         //         message: Text("LS_Thes Books dasent exist: \(getnotExistingBooks())" as LocalizedStringKey),
                  message: errorText1 == "" ? Text(errorText) : Text(errorText1),
                  primaryButton: .default(Text("LS_More information" as LocalizedStringKey),
                                          action: {
                                            infoIsVisible.toggle()
                                          }),
                  secondaryButton: .cancel(Text("LS_Oky" as LocalizedStringKey))
            )
        }
    }
    func getnotExistingBooks(allNonExistentBooks: [String]?) -> String {
        
        var existingBooksString: String = "\n"
        
        allNonExistentBooks!.forEach{ bookID in
            existingBooksString = existingBooksString + bookID + "\n"
        }
        return existingBooksString
    }
    
}
