//
//  BookInfoView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookInfoView: View {
    
    @Environment(\.managedObjectContext) var viewContext

    
    @ObservedObject var book: Book
    @Binding var editMode: Bool
    @State var showingPopup = false
    @Binding var updateView: Bool
    
    var body: some View {
        
        VStack {
            HStack{
                Text("Title: ").foregroundColor(Color(UIColor.black))
                TextField(book.title!, text: umwantler(binding: $book.title, fallback: "nil"), onEditingChanged: {(changed) in
                    if changed == false {
                        saveContext()
                        updateView.toggle()
                    }
                })
            }
            
            
            
            HStack{
                Text("Tonality: ")
                if editMode {
                    TextField("\(book.tonArt ?? "nil")", text: umwantler(binding: $book.tonArt, fallback: "error")).padding(0).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
                } else {
                    Text("\(book.tonArt ?? "nil")")
                }
                Spacer()
            }.padding(.bottom, 4)

            HStack{
                Text("Version: ")
                if editMode {
                    TextField("\(book.version ?? "nil")", text: umwantler(binding: $book.version, fallback: "error")).padding(0).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
                } else {
                    Text("\(book.version ?? "nil")")
                }
                Spacer()
            }.padding(.bottom, 4)
            
            HStack{
                Text("\(String(book.songs!.count)) Songs")
                Spacer()
            }.padding(.bottom, 4)
            
            HStack{
                Text("Page Offset: ")
                if editMode {
                    TextField("\(book.pageOfset ?? "nil")", text: umwantler(binding: $book.pageOfset, fallback: "error")).padding(0).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
                } else {
                    Text("\(book.pageOfset ?? "nil")")
                    Spacer()
                }
                
                Button(action: {
                    showingPopup.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .popover(isPresented: self.$showingPopup) {
                            Text("Das sind die Infos zum dem Page Offset").padding()
                    }
                }
            }.padding(.bottom, 4).padding(.top, 4)
        }.frame(minWidth: 100, maxHeight: .infinity)
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
        
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
