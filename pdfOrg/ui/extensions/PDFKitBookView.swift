//
//  PDFKitBookView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI
import PDFKit

struct PDFKitBookView: View {
    @State var book: Book
    @Binding var pageIndex: Int
    //  @State var presentationModde: Bool
    
    
    var body: some View {
        VStack{
            PDFPreviewController(pdfX: $book , pageIndex: $pageIndex)
        }
    }
}

//class PDFPreviewViewConroller: UIViewController {
//
//    public var pdfView: PDFView!
//
//    override func loadView() {
//
//        pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        self.view = pdfView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//}

struct PDFPreviewController: UIViewControllerRepresentable {
    
    @Binding var book: Book
    @Binding var pageIndex: Int
  
    //   @State var pdfView: PDFView = PDFView()
    //  @Binding var presentationModde: Bool
    
    init(pdfX: Binding<Book>, pageIndex: Binding<Int>/*, presentationModde: Binding<Bool>*/) {
        _book = pdfX
        _pageIndex = pageIndex
        //   _presentationModde = presentationModde
      
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PDFPreviewController>) -> PDFViewController {
        
        let view = PDFViewController()
        //view.pdfView.delegate = context.coordinator
        //    pdfView = view.pdfView
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: PDFViewController, context: UIViewControllerRepresentableContext<PDFPreviewController>) {
        
        
        uiViewController.pdfView.delegate = context.coordinator
        
        
        let gRecognizer  = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.touchAction(gestureReconizer:)))
  //          let dRecognizer = UISwipeGestureRecognizer(target: context.coordinator, action:  #selector(Coordinator.swipeGestureAction(gestureReconizer:)))
        
         uiViewController.pdfView.addGestureRecognizer(gRecognizer)
    //     uiViewController.pdfView.addGestureRecognizer(dRecognizer)
        uiViewController.pdfView.document = PDFDocument(data: book.pdf!)
        
        //        if presentationModde {
         //       uiViewController.pdfView.displayMode = PDFDisplayMode.singlePage
        //        }
        
        var calculatedPage: Int = pageIndex + Int(book.pageOfset ?? "0")!
        calculatedPage = calculatedPage - 1
        
        if let myPage = uiViewController.pdfView.document?.page(at: (calculatedPage
        )) {
            
            uiViewController.pdfView.go(to: myPage)
        }
        //        if presentationModde{
          uiViewController.pdfView.backgroundColor = UIColor.white
      //  uiViewController.pdfView.backgroundColor = UIColor.black
        uiViewController.pdfView.autoScales = true      //TODO: fukk
        //        }
        uiViewController.pdfView.displayMode = PDFDisplayMode.singlePage//Continuous
     //   uiViewController.pdfView.autoScales = true
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(book: $book, pageIndex: $pageIndex, self)
    }

    
    class Coordinator: NSObject, PDFViewDelegate {

        @Binding var pageIndex: Int
        @Binding var book: Book
        var parent: PDFPreviewController
        //     @State var pdfView: PDFView
        //        @Binding var index: Int {
        //            didSet {
        //                print("\(pdfView.document?.index(for: pdfView.currentPage!))")
        //                index = 2
        //            }
        //        }
        
        init(book: Binding<Book>, pageIndex: Binding<Int>,_ parent: PDFPreviewController) {
            _pageIndex = pageIndex
            _book = book
            self.parent = parent
            //  pdfView = view
        }
        
      
        
        @objc func touchAction(gestureReconizer: UITapGestureRecognizer) {
            print("touchAction \((((gestureReconizer.view as! PDFView).document?.index(for:  (gestureReconizer.view as! PDFView).currentPage!))!) + 1 + Int(book.pageOfset!)!)")
            // pageIndex = 1
            pageIndex = ((gestureReconizer.view as! PDFView).document?.index(for:  (gestureReconizer.view as! PDFView).currentPage!))! + 1 + Int(book.pageOfset!)!
       //     ec.pageIndex = pageIndex
            
        }
        
//                @objc func swipeGestureAction(gestureReconizer: UISwipeGestureRecognizer) {
//                    print(gestureReconizer.direction)
//                    print("swipeGestureAction")
//                }
        //
        //
        //        @objc func swipeGestureAction2(gestureReconizer: PDFrec) {
        //        print("swipeGestureAction")
        //       }
        //        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //            if completed {
        //            print("pageViewController")
        //            } else {
        //                print("pageViewController2")
        //            }
        //        }
        
        
        
        
        
    }
}

