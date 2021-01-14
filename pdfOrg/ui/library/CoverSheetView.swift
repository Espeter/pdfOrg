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
    
    var body: some View {
        
        if book.coverSheet != nil {
            VStack{
                NavigationLink(destination: BookView(book: book), isActive: $navigationLinkActive) { EmptyView() }
            Image(uiImage: UIImage(data: book.coverSheet!)!)
                .resizable()
                .frame(width: 151.2, height: 213.84)
                .cornerRadius(15.0)
                .shadow( radius: 15, x: 3, y: 5)
                .padding()
                .onTapGesture {
                    showingPopup.toggle()
                }
                .popover(isPresented: self.$showingPopup) {
                    VStack{
                        Text("title: \(book.title ?? "n.a.")")
                        Text("version: \(book.version ?? "n.a.")")
                        Text("tonArt: \(book.tonArt ?? "n.a.")")
                        Text("\(String(book.songs!.count)) Songs")
                        Button(action: {
                            viewContext.delete(book)
                            saveContext()
                        }) {
                            Image(systemName: "trash").padding()
                        }
                        Button(action: {
                            navigationLinkActive.toggle()
                            showingPopup = false
                        }) {
                            Image(systemName: "book").padding()
                        }
                        
                    }.padding().frame(width: 200, height: 300)
                }
            }
        } else {
            
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 151.2, height: 213.84)
                .cornerRadius(15.0)
                .shadow( radius: 15, x: 3, y: 5)
                .padding()
                .onTapGesture {
                    showingPopup.toggle()
                }
                .popover(isPresented: self.$showingPopup) { //trailing
                    VStack{
                        Text("title: \(book.title ?? "n.a.")")
                        Text("version: \(book.version ?? "n.a.")")
                        Text("tonArt: \(book.tonArt ?? "n.a.")")
                        Button(action: {
                            viewContext.delete(book)
                            saveContext()
                        }) {
                            Image(systemName: "trash")
                        }
                    }.padding().frame(width: 200, height: 300)
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

