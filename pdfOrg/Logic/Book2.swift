//
//  Book2.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.03.21.
//

import Foundation

import Foundation
import SwiftUI

class Book2 {
    
    public var book: Book
    
    public var songs: [Song]
 //   public var id: String
//    public var isLandscape: Int
//    public var label: String
//    public var pageOfSet: String
//    public var pdfTitle: String
 //   public var title: String
    
    //    private var viewContext: NSManagedObjectContext  {
    //        return PersistenceController.shared.container.viewContext
    //    }
    
    init(book: Book) {
        
        self.book = book
        
        self.songs = []
    //    print(book.id ?? "error_no id")
     //   self.id = book.id ?? "error_no id"
    //    self.isLandscape = Int( book.isLandscape)
//        self.label = book.label ?? ""
//        self.pageOfSet = book.pageOfset ?? "0"
//        self.pdfTitle = book.pdfTitle ?? "error_no pdfTitel"
 //       self.title = book.title ?? "error_ no Tieletel"
        
        book.songs?.forEach {song in
            songs.append(song as! Song)
        }
    }
    
    
    
    
}
