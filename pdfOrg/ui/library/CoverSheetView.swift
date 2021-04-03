//
//  CoverSheetView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI

struct CoverSheetView: View {
    
    @EnvironmentObject var ec : EnvironmentController
    
    @State var book: Book
    @State var selectedSong: Song?
    
    var body: some View {
        
        if book.coverSheet != nil {
            VStack{
                if ec.currentBook != nil {
                    
                    NavigationLink(destination: Book2View(book: ec.currentBook!), isActive: $ec.navigationLinkActive) { EmptyView() }.animation(nil)
                }
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: UIImage(data: book.coverSheet!)!)
                        .resizable()
                        .frame(width: getWidth(), height: getHeight())
                        .onTapGesture {
                            ec.currentBook = book
                            ec.navigationLinkActive.toggle()
                        }
                        .cornerRadius(15.0)
                        .shadow( radius: 8, x: 3, y: 5)
                }
                Text(book.title ?? "error_no Titel")
                    .font(.footnote)
                    .frame(width: getWidth(), height: 35)
            } .padding()
        }
    }
    private func getWidth() -> CGFloat? {
        var width: CGFloat?
        if book.isLandscape == 1 {
            width = 213.84
        } else {
            width = 151.2
        }
        return width
    }
    
    private func getHeight() -> CGFloat? {
        var height: CGFloat?
        if book.isLandscape == 1 {
            height = 151.2
        } else {
            height = 213.84
        }
        return height
    }
}

