//
//  LibraryViewExtension.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI
import PDFKit

extension LibraryView {
    
    func getArrayBook(_ books: FetchedResults<Book>) -> [Book] {
        var booksArray: [Book] = []
        
        books.forEach{ book in
            booksArray.append(book)
        }
        
        booksArray.sort {
            $0.title!.lowercased() < $1.title!.lowercased()
        }
        return booksArray
    }
    
    func addBook(url: URL) {
        
        let newBook = Book(context: viewContext)
        newBook.pdfTitle = url.lastPathComponent
        let title: String = url.lastPathComponent
        newBook.title = String(title.dropLast(4))
        newBook.id = generateID(titel: newBook.title!)
        newBook.pageOfset = "0"
        newBook.label = ""
        newBook.version = "n.a."
        newBook.isLandscape = 0
        
        do{
            guard url.startAccessingSecurityScopedResource() else {
                return
            }
            newBook.pdf = try Data( contentsOf: url)
            newBook.coverSheet = getCoverSheet(data: newBook.pdf!)?.jpegData(compressionQuality: 1.0)
        }  catch {
            print("error: \(error)")
        }
        saveContext()
        ec.updateGigInfoView.toggle()
        url.stopAccessingSecurityScopedResource()
    }
    
    func generateID(titel: String) -> String {
        
        var id: String
        var idExistsAlready = false
        
        books.forEach{ book in
            if book.id == titel {
                idExistsAlready = true
            }
        }
        
        if idExistsAlready {
            
            let newTitel = titel + "(new)"
            
            return generateID(titel: newTitel)
            
        } else {
            id = titel
        }
        
        return id
    }
    
    
    private func getCoverSheet(data: Data) -> UIImage? {
        
        guard let pdf = PDFDocument(data: data) else { return nil }
        
        guard let page = pdf.page(at: 0) else { return nil }
        
        // Quellle: https://www.hackingwithswift.com/example-code/core-graphics/how-to-render-a-pdf-to-an-image
        // Quellle: https://pspdfkit.com/blog/2020/convert-pdf-to-image-in-swift/
        let pageRect = page.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            page.draw(with: .mediaBox, to: ctx.cgContext)
        }
        return img
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
}
