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
    
    var body: some View {
        
        VStack {
            
            HStack{
                Text("tonArt: ")
                if editMode {
                    TextField("\(book.tonArt ?? "nil")", text: umwantler(binding: $book.tonArt, fallback: "error")).padding(0).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
                } else {
                    Text("\(book.tonArt ?? "nil")")
                }
                Spacer()
            }.padding(.bottom, 4)

            HStack{
                
                Text("version: ")
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
                Text("pageOfset: ")
                if editMode {
                    TextField("\(book.pageOfset ?? "nil")", text: umwantler(binding: $book.pageOfset, fallback: "error")).padding(0).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
                } else {
                    Text("\(book.pageOfset ?? "nil")")
                    Spacer()
                }
                
                Button(action: {
                    print("info")
                }) {
                    Image(systemName: "info.circle")
                }
            }.padding(.bottom, 4).padding(.top, 4)

        }.frame( height: 125)
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
}
