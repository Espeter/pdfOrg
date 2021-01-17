//
//  LibraryView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI

struct LibraryView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    private var books: FetchedResults<Book>
    
    @State private var searchText = ""
    @State private var openFile = false
    
    @State private var popupIsActive = false
    @State private var currentBook: Book?

    
    @State private var navigationLinkActive = false
    
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
                        ForEach(books) { book in
                            
                            CoverSheetView(navigationLinkActive: $navigationLinkActive, book: book, popupIsActive: $popupIsActive, currentBook: $currentBook)
                        }
                    }.frame(height: 300).padding(.bottom, -20)
                }
                Divider()
                Spacer()
                Text("")
            }.background(Color(UIColor.systemBlue).opacity(0.05))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    HStack{
                                        SearchBar(text: $searchText).frame(width: 300)
                                        Image(systemName: "house").padding()
                                        Text("Gerne")
                                        Text("|")
                                        Text("Autor")
                                    }
                                ,trailing:
                                    HStack{
                                        Button(action: {
                                            openFile.toggle()
                                        }) {
                                            Image(systemName: "square.and.arrow.down")
                                        }
                                    }
            )
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf])
            { (res) in
                do {
                    let fileUrl = try res.get()
                    
                    addBool(url: fileUrl)
                }
                catch {
                    print("error")
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
