//
//  BookView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookView: View {
    
    @State var book: Book
    
    var body: some View {
        
        HStack{
            VStack{
                BookInfoView(book: book)
                    .padding()
                    .shadow( radius: 15, x: 3, y: 5)
                BookPDFView(book: book)
                    .padding()
                    .shadow( radius: 15, x: 3, y: 5)

            }
            BookmarkCollectionView(book: book)
                .padding()
                .frame(width: 650)
                .shadow( radius: 15, x: 3, y: 5)

            
        }.background(Color(UIColor.systemBlue).opacity(0.05))
        .navigationBarTitle("\(book.title ?? "nil")")
        .navigationBarItems(trailing:
                HStack{
                    Button(action: {
                        print("foo1")
                    }) {
                        Image(systemName: "square.and.arrow.down")

                    }
                    Button(action: {
                        print("foo2")
                    }) {
                        Image(systemName: "plus").padding()
                    }
                    
                }
        )
    }
}
