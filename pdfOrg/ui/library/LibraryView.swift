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
    
    var body: some View {
        NavigationView(){
            VStack{
               
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
              //  List(){
                    
                    ForEach(books) { book in
//                        NavigationLink(destination: PDFOverviewView(pdf: pdf)) {
                            Text(book.title ?? "error")
                        if book.coverSheet != nil {
                            Image(uiImage: UIImage(data: book.coverSheet!)!).cornerRadius(0.55).frame(width: 210, height: 297)
                        }
                            
//                        }
   //                 }
                
                }
            }.background(Color(UIColor.systemBlue).opacity(0.15))
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    HStack{
                                    SearchBar(text: $searchText).frame(width: 300)
                                        Image(systemName: "house").padding()
                                        Text("Gorne")
                                        Text("|")
                                        Text("Autor")
                                    }
                                ,trailing:
                                    Button(action: {
                                        openFile.toggle()
                                    }) {
                                        Image(systemName: "square.and.arrow.down")
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
