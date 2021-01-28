//
//  PDFKitBookPresentationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.01.21.
//

//import SwiftUI
//import PDFKit
//
//struct PDFKitBookPresentationView: View {
//    
//    @Binding var book: Book
//    @Binding var pageIndex: Int
//    @Binding var isLandscape: Bool
//    
//    @State var orientation = UIDevice.current.orientation
//    
//    var onAppearOrientation = UIApplication.shared.statusBarOrientation //TODO: dass muss noch apgedaydet werden
//    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
//        .makeConnectable()
//        .autoconnect()
//    
//    var body: some View {
//        
//        PDFPreviewControllerBook(book: $book , pageIndex: $pageIndex, isLandscape: $isLandscape )
//            .onReceive(orientationChanged) { _ in
//                self.orientation = UIDevice.current.orientation
//                if  self.orientation.isLandscape {
//                    isLandscape = true
//                } else {
//                    isLandscape = false
//                }
//            }.onAppear() {
//                if onAppearOrientation.isLandscape {
//                    isLandscape = true
//                } else {
//                    isLandscape = false
//                }
//            }
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
//struct PDFPreviewControllerBook: UIViewControllerRepresentable {
//    
//    @Binding var book: Book
//    @Binding var pageIndex: Int
//    //  @Binding var presentationModde: Bool
//    @Binding var isLandscape: Bool
//    
//    init(book: Binding<Book>, pageIndex: Binding<Int>, isLandscape: Binding<Bool>) {
//        _book = book
//        _pageIndex = pageIndex
//        //    _presentationModde = presentationModde
//        _isLandscape = isLandscape
//    }
//    
//    func makeUIViewController(context: UIViewControllerRepresentableContext<PDFPreviewControllerBook>) -> PDFViewController {
//        
//        return PDFViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: PDFViewController, context: UIViewControllerRepresentableContext<PDFPreviewControllerBook>) {
//        
//        
//        //      var document = PDFDocument(data: book.pdf!)
//        
//        uiViewController.pdfView.document = PDFDocument(data: book.pdf!)
//        
//        //        if presentationModde {
//        //            uiViewController.pdfView.displayMode = PDFDisplayMode.twoUp
//        //        }
//        
//        let pageIndexInt = pageIndex
//        var calculatedPage: Int = pageIndexInt + Int(book.pageOfset ?? "0")!
//        calculatedPage = calculatedPage - 1
//        // uiViewController.pdfView.backgroundColor = UIColor.white
//        
//        if calculatedPage % 2 != 0 {
//            // uiViewController.pdfView.document?.removePage(at: 0)
//            uiViewController.pdfView.document?.insert(PDFPage(), at: 0)
//            calculatedPage = calculatedPage + 1
//        }
//        
//        
//        
//        
//        if let myPage = uiViewController.pdfView.document?.page(at: (calculatedPage )) {
//            uiViewController.pdfView.go(to: myPage)
//        }
//        //        if presentationModde{
//        //            uiViewController.pdfView.autoScales = true
//        //        }
//        
//        if isLandscape {
//            uiViewController.pdfView.displayMode = PDFDisplayMode.twoUp
//            uiViewController.pdfView.autoScales = true
//        } else {
//            uiViewController.pdfView.displayMode = PDFDisplayMode.singlePage
//            uiViewController.pdfView.autoScales = true
//        }
//        
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(book: $book, pageIndex: $pageIndex, isLandscape: $isLandscape)
//    }
//    
//    class Coordinator: NSObject {
//        
//        @Binding var pageIndex: Int
//        @Binding var book: Book
//        @Binding var isLandscape: Bool
//        
//        init(book: Binding<Book>, pageIndex: Binding<Int>, isLandscape: Binding<Bool>) {
//            _pageIndex = pageIndex
//            _book = book
//            _isLandscape = isLandscape
//        }
//    }
//}
