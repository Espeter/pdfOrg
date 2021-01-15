//
//  PDFKitBookView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI
import PDFKit

struct PDFKitView: View {
    @State var book: Book
    @Binding var pageIndex: Int
  //  @State var presentationModde: Bool
    
    
    var body: some View {
        VStack{
            PDFPreviewController(pdfX: $book , pageIndex: $pageIndex)
        }
    }
}

class PDFPreviewViewConroller: UIViewController {
    
    public var pdfView: PDFView!
    
    override func loadView() {
        
        pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.view = pdfView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

struct PDFPreviewController: UIViewControllerRepresentable {
    
    @Binding var book: Book
    @Binding var pageIndex: Int
  //  @Binding var presentationModde: Bool
    
    init(pdfX: Binding<Book>, pageIndex: Binding<Int>/*, presentationModde: Binding<Bool>*/) {
        _book = pdfX
        _pageIndex = pageIndex
     //   _presentationModde = presentationModde
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PDFPreviewController>) -> PDFPreviewViewConroller {
        
        return PDFPreviewViewConroller()
    }
    
    func updateUIViewController(_ uiViewController: PDFPreviewViewConroller, context: UIViewControllerRepresentableContext<PDFPreviewController>) {
        
        uiViewController.pdfView.document = PDFDocument(data: book.pdf!)
        
//        if presentationModde {
//        uiViewController.pdfView.displayMode = PDFDisplayMode.singlePage
//        }
        if let myPage = uiViewController.pdfView.document?.page(at: (pageIndex)) {
            uiViewController.pdfView.go(to: myPage)
        }
//        if presentationModde{
        uiViewController.pdfView.backgroundColor = UIColor.white
        uiViewController.pdfView.autoScales = true
//        }
        
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

