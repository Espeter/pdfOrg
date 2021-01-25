//
//  BookPDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookPDFView: View {
    
    @EnvironmentObject var ec : EnvironmentController
    @Environment(\.managedObjectContext) private var viewContext

    @State var book: Book
    @Binding var song: Song?
    
    @Binding var page: Int
    
    var body: some View {
        HStack() {
            Button(action: {
                if page > 0 {
                    page = page - 1
                    getSong()
                }
            }) {
                Image(systemName: "lessthan")
            }
            ZStack(alignment: .topTrailing) {
            PDFKitBookView(book: book, pageIndex: $page).frame(width: 300, height: 380.5)
                .onTapGesture {
                    ec.presentationModeBook = true
                    ec.pageIndex = page
                    ec.book = book
                    print("cloud.bolt.rain: \(page)")
                }
                if song != nil {
                    if song!.isFavorit {
                        Button(action: {
                            song!.isFavorit = false
                            saveContext()
                        }) {
                            Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                        }
                    } else {
                        Button(action: {
                            song!.isFavorit = true
                            saveContext()
                        }) {
                            Image(systemName: "star").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                        }
                    }
                }
            }
            Button(action: {
                page = page + 1
                getSong()
            }) {
                Image(systemName: "greaterthan")
            }
        }
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
        .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width <= 0 {
                            page = page + 1
                            getSong()
                        }
                        if value.translation.width >= 0 {
                            if page > 0 {
                                page = page - 1
                                getSong()
                            }
                        }
                    }))
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
    
    func getSong() {
        
        let songs = book.songs
        var songFound = false
        songs?.forEach { song in
            
            if (song as! Song).startPage != (song as! Song).endPage && songFound == false{
                
                let startPage = Int((song as! Song).startPage!)
                let endPage = Int((song as! Song).endPage ?? (song as! Song).startPage!)
                let pageCount = endPage! - startPage!

                (0..<(pageCount + 1)).forEach { i in
                    if (startPage! + i) == page && songFound == false{
                        self.song = (song as! Song)
                        songFound = true
                        print("songFound \(songFound)")
                    } else if songFound == false {
                        self.song = nil
                    }
                }
            } else if songFound == false{
                if (song as! Song).startPage == String(page) {
                    self.song = (song as! Song)
                    print("songFound2 true")
                } else {
                    self.song = nil
                }
            }
        }
    }
    
//    func pageIsSong() -> Bool {
//
//        var isSong = false
//        let songs = book.songs
//
//        songs?.forEach { song in
//
//            if (song as! Song).startPage != (song as! Song).endPage {
//
//                let startPage = Int((song as! Song).startPage!)
//                let endPage = Int((song as! Song).endPage ?? (song as! Song).startPage!)
//                let pageCount = endPage! - startPage!
//
//                (0..<(pageCount + 1)).forEach { i in
//                    if (startPage! + i) == page {
//                        isSong = true
//                        self.song = (song as! Song)
//                    }
//                }
//            } else {
//                if (song as! Song).startPage == String(page) {
//                    isSong = true
//                    self.song = (song as! Song)
//                }
//            }
//        }
//        return isSong
//    }
}
