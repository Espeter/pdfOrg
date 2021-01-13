//
//  LibraryViewExtension.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI
import PDFKit

extension LibraryView {
    
    func addBool(url: URL) {
        
        let newBook = Book(context: viewContext)
        newBook.id = UUID()
        newBook.title = url.lastPathComponent
        newBook.pageOfset = 0
        newBook.tonArt = "n.a."
        newBook.version = "n.a."
        
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
        url.stopAccessingSecurityScopedResource()
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
