//
//  PDFKitCampirePresentationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.01.21.
//

//import SwiftUI
//import PDFKit
//
//struct PDFKitCampirePresentationView: View {
//    @Binding var book: Book
//    @Binding var pageIndex: String
//    @State var presentationModde: Bool
//    
//    @State var orientation = UIDevice.current.orientation
//    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
//            .makeConnectable()
//            .autoconnect()
//    
//    var body: some View {
//        VStack{
//            if orientation.isLandscape {
//                PDFPreviewControllerPresentationCampire(book: $book , pageIndex: $pageIndex, presentationModde: $presentationModde, isLandscape: true )
//            } else {
//                PDFPreviewControllerPresentationCampire(book: $book , pageIndex: $pageIndex, presentationModde: $presentationModde, isLandscape: false )
//            }
//        }.onReceive(orientationChanged) { _ in
//            self.orientation = UIDevice.current.orientation
//    }
//    }
//}
//
////class PDFPreviewViewControllerCampirePresentation: UIViewController {
////    
////    public var pdfView: PDFView!
////    
////    override func loadView() {
////        
////        pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
////        
////        self.view = pdfView
////    }
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////    }
////}
//
//struct PDFPreviewControllerPresentationCampire: UIViewControllerRepresentable {
//    
//    @Binding var book: Book
//    @Binding var pageIndex: String
//    @Binding var presentationModde: Bool
//    
//    var isLandscape: Bool
//    
//    init(book: Binding<Book>, pageIndex: Binding<String>, presentationModde: Binding<Bool>, isLandscape: Bool) {
//        _book = book
//        _pageIndex = pageIndex
//        _presentationModde = presentationModde
//        self.isLandscape = isLandscape
//    }
//    
//    func makeUIViewController(context: UIViewControllerRepresentableContext<PDFPreviewControllerPresentationCampire>) -> PDFViewController {
//        
//        return PDFViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: PDFViewController, context: UIViewControllerRepresentableContext<PDFPreviewControllerPresentationCampire>) {
//        
//        uiViewController.pdfView.document = PDFDocument(data: book.pdf!)
//        
//        if presentationModde {
//            uiViewController.pdfView.displayMode = PDFDisplayMode.singlePage
//        }
//        
//        let pageIndexInt = Int(pageIndex)!
//        var calculatedPage: Int = pageIndexInt + Int(book.pageOfset ?? "0")!
//        calculatedPage = calculatedPage - 1
//        uiViewController.pdfView.backgroundColor = UIColor.white
//
//        if let myPage = uiViewController.pdfView.document?.page(at: (calculatedPage )) {
//            uiViewController.pdfView.go(to: myPage)
//        }
//      
//        if presentationModde{
//            uiViewController.pdfView.autoScales = true
//        }
//        if isLandscape {
//            uiViewController.pdfView.displayMode = PDFDisplayMode.twoUp
//        } else {
//            uiViewController.pdfView.displayMode = PDFDisplayMode.singlePage
//        }
//        
//     
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(book: $book, pageIndex: $pageIndex)
//    }
//    
//    class Coordinator: NSObject {
//        
//        @Binding var pageIndex: String
//        @Binding var book: Book
//        
//        init(book: Binding<Book>, pageIndex: Binding<String>) {
//            _pageIndex = pageIndex
//            _book = book
//        }
//    }
//}
//
