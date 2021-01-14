//
//  BookInfoView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookInfoView: View {
    
    @ObservedObject var book: Book
    @Binding var editMode: Bool
    
    @State var foo = ""
    
    var body: some View {
        
        VStack{
            if editMode {
                HStack{
                    Text("tonArt: ")
                    TextField("\(book.tonArt ?? "nil")", text: umwantler(binding: $book.tonArt, fallback: "error")).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
                }
                HStack{
                    Text("version: ")
                    TextField("\(book.version ?? "nil")", text: umwantler(binding: $book.version, fallback: "error")).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
                }
                Text("\(String(book.songs!.count)) Songs")
                Divider()
                HStack{
                    Text("pageOfset: \(String(book.pageOfset))")
                    Spacer()
                    Button(action: {
                        print("\(editMode)")
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
                
            } else {
                
                Text("tonArt: \(book.tonArt ?? "nil")")
                Text("version: \(book.version ?? "nil")")
                Text("\(String(book.songs!.count)) Songs")
                Divider()
                HStack{
                    Text("pageOfset: \(String(book.pageOfset))")
                    Spacer()
                    Button(action: {
                        print("\(editMode)")
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
            }
        }.padding()
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
}
