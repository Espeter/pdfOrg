//
//  BookInfoView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookInfoView: View {
    
    @State var book: Book
    
    var body: some View {
        
        VStack{
            Text("tonArt: \(book.tonArt ?? "nil")")
            Text("version: \(book.version ?? "nil")")
            Divider()
            Text("pageOfset: \(String(book.pageOfset))")
        }.padding()
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
        
    }

}
