//
//  PDFPresentationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 28.01.21.
//

import SwiftUI
import PDFKit

struct PDFPresentationView: View {
    
    @Binding var book: Book
    @Binding var pageIndex: String
    @Binding var isLandscape: Bool
    
    @State var orientation = UIDevice.current.orientation
    
    var onAppearOrientation = UIApplication.shared.statusBarOrientation //TODO: dass muss noch apgedaydet werden
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    var body: some View {
        PDFPresentationViewCR(book: $book, pageIndex: $pageIndex, isLandscape: $isLandscape)
            .onReceive(orientationChanged) { _ in
                self.orientation = UIDevice.current.orientation
                if  self.orientation.isLandscape {
                    isLandscape = true
                } else {
                    isLandscape = false
                }
            }.onAppear() {
                if onAppearOrientation.isLandscape {
                    isLandscape = true
                } else {
                    isLandscape = false
                }
            }
    }
}

struct PDFPresentationViewCR: UIViewControllerRepresentable {
    
    @Binding var book: Book
    @Binding var pageIndex: String
    @Binding var isLandscape: Bool

    init(book: Binding<Book>, pageIndex: Binding<String>, isLandscape: Binding<Bool>) {
        _book = book
        _pageIndex = pageIndex
        _isLandscape = isLandscape
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PDFPresentationViewCR>) -> PDFViewController {
        
        return PDFViewController()
    }
    
    func updateUIViewController(_ uiViewController: PDFViewController, context: UIViewControllerRepresentableContext<PDFPresentationViewCR>) {
        
        uiViewController.pdfView.document = PDFDocument(data: book.pdf!)
        
        let pageIndexInt = Int(pageIndex)!
        var calculatedPage: Int = pageIndexInt + Int(book.pageOfset ?? "0")!
        calculatedPage = calculatedPage - 1

        if calculatedPage % 2 != 0 {
            uiViewController.pdfView.document?.insert(PDFPage(), at: 0)
            calculatedPage = calculatedPage + 1
        }
        
        if let myPage = uiViewController.pdfView.document?.page(at: (calculatedPage )) {
            uiViewController.pdfView.go(to: myPage)
        }
        
        if isLandscape {
            uiViewController.pdfView.displayMode = PDFDisplayMode.twoUp
        } else {
            uiViewController.pdfView.displayMode = PDFDisplayMode.singlePage
        }
        
        uiViewController.pdfView.autoScales = true

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(book: $book, pageIndex: $pageIndex, isLandscape: $isLandscape)
    }
    
    class Coordinator: NSObject {
        
        @Binding var pageIndex: String
        @Binding var book: Book
        @Binding var isLandscape: Bool
        
        init(book: Binding<Book>, pageIndex: Binding<String>, isLandscape: Binding<Bool>) {
            _pageIndex = pageIndex
            _book = book
            _isLandscape = isLandscape
        }
    }
}
