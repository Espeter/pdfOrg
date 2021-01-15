//
//  BookPDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookPDFView: View {
    
    @State var book: Book
    
    @Binding var page: Int //= 0
    
    var body: some View {
        VStack{
            PDFKitView(book: book, pageIndex: $page).frame(width: 300, height: 380.5)
        }
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
    }
}
