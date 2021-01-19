//
//  PDFKitBookPresentationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.01.21.
//

import SwiftUI

import SwiftUI
import PDFKit

struct PDFKitBookPresentationView: View {
    @Binding var book: Book
    @Binding var pageIndex: Int
    @State var presentationModde: Bool
    
    
    var body: some View {
        VStack{
            PDFPreviewControllerBook(book: $book , pageIndex: $pageIndex, presentationModde: $presentationModde )
        }
    }
}

class PDFPreviewViewControllerBook: UIViewController {
    
    public var pdfView: PDFView!
    
    override func loadView() {
        
        pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.view = pdfView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

struct PDFPreviewControllerBook: UIViewControllerRepresentable {
    
    @Binding var book: Book
    @Binding var pageIndex: Int
    @Binding var presentationModde: Bool
    
    init(book: Binding<Book>, pageIndex: Binding<Int>, presentationModde: Binding<Bool>) {
        _book = book
        _pageIndex = pageIndex
        _presentationModde = presentationModde
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PDFPreviewControllerBook>) -> PDFPreviewViewControllerBook {
        
        return PDFPreviewViewControllerBook()
    }
    
    func updateUIViewController(_ uiViewController: PDFPreviewViewControllerBook, context: UIViewControllerRepresentableContext<PDFPreviewControllerBook>) {
        
        uiViewController.pdfView.document = PDFDocument(data: book.pdf!)
        
        if presentationModde {
            uiViewController.pdfView.displayMode = PDFDisplayMode.twoUp
        }
        
        let pageIndexInt = pageIndex
        var calculatedPage: Int = pageIndexInt + Int(book.pageOfset ?? "0")!
        calculatedPage = calculatedPage - 1
        uiViewController.pdfView.backgroundColor = UIColor.white

        if let myPage = uiViewController.pdfView.document?.page(at: (calculatedPage )) {
            uiViewController.pdfView.go(to: myPage)
        }
        if presentationModde{
            uiViewController.pdfView.autoScales = true
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(book: $book, pageIndex: $pageIndex)
    }
    
    class Coordinator: NSObject {
        
        @Binding var pageIndex: Int
        @Binding var book: Book
        
        init(book: Binding<Book>, pageIndex: Binding<Int>) {
            _pageIndex = pageIndex
            _book = book
        }
    }
}
