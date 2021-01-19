//
//  BookPDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookPDFView: View {
    
    @EnvironmentObject var ec : EnvironmentController
    
    @State var book: Book
    
    @Binding var page: Int //= 0
    
    var body: some View {
        HStack() {
            Button(action: {
                if page > 0 {
                page = page - 1
                }
            }) {
                Image(systemName: "lessthan")
            }
            PDFKitBookView(book: book, pageIndex: $page).frame(width: 300, height: 380.5)
                .onTapGesture {
                ec.presentationModeBook = true
                ec.pageIndex = page
                ec.book = book
                print("cloud.bolt.rain: \(page)")
            }
            Button(action: {
                page = page + 1
            }) {
            Image(systemName: "greaterthan")
            }
//            Button(action: {
//                ec.presentationModeBook = true
//                ec.pageIndex = page
//                ec.book = book
//                print("cloud.bolt.rain: \(page)")
//
//            }) {
//                Image(systemName: "arrow.up.left.and.arrow.down.right").padding()
//            }
        }
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
     
        .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width <= 0 {
                            page = page + 1
                        }
                        if value.translation.width >= 0 {
                            if page > 0 {
                            page = page - 1
                            }
                        }
                    }))
    }
}
