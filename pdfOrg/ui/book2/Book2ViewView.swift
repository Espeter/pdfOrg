//
//  Book2ViewView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.03.21.
//

import SwiftUI

struct Book2ViewView: View {
    
    @State var book: Book
    @Binding var page: Int
    
    var body: some View {
        ZStack{
            PDFKitBookView(book: book, pageIndex: $page)
        }
    }
}
