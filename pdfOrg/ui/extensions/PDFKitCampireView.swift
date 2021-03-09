//
//  PDFKitCampireView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 17.01.21.
//

import SwiftUI
import PDFKit

struct PDFKitCampireView: View {
    @Binding var book: Book
    @Binding var pageIndex: String
    @State var presentationModde: Bool
    
    
    var body: some View {
        VStack{
            PDFPreviewControllerCampire(book: $book , pageIndex: $pageIndex, presentationModde: $presentationModde )
        }
    }
}

//class PDFPreviewViewControllerCampire: UIViewController {
//
//    public var pdfView: PDFView!
//
//    override func loadView() {
//
//        pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//
//        self.view = pdfView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}

struct PDFPreviewControllerCampire: UIViewControllerRepresentable {
    
    @Binding var book: Book
    @Binding var pageIndex: String
    @Binding var presentationModde: Bool
    
    init(book: Binding<Book>, pageIndex: Binding<String>, presentationModde: Binding<Bool>) {
        _book = book
        _pageIndex = pageIndex
        _presentationModde = presentationModde
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PDFPreviewControllerCampire>) -> PDFViewController {
        
        return PDFViewController()
    }
    
    func updateUIViewController(_ uiViewController: PDFViewController, context: UIViewControllerRepresentableContext<PDFPreviewControllerCampire>) {
        
        uiViewController.pdfView.document = PDFDocument(data: book.pdf!)
        
        if presentationModde {
            uiViewController.pdfView.displayMode = PDFDisplayMode.singlePage
        }
        
        let pageIndexInt = Int(pageIndex)!
        var calculatedPage: Int = pageIndexInt + Int(book.pageOfset ?? "0")!
        calculatedPage = calculatedPage - 1
    //    uiViewController.pdfView.backgroundColor = UIColor.white

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
        
        @Binding var pageIndex: String
        @Binding var book: Book
        
        init(book: Binding<Book>, pageIndex: Binding<String>) {
            _pageIndex = pageIndex
            _book = book
        }
    }
}
