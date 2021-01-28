//
//  PDFViewController.swift
//  pdfOrg
//
//  Created by Carl Espeter on 28.01.21.
//

import PDFKit

class PDFViewController: UIViewController {
    
    public var pdfView: PDFView!
    
    override func loadView() {
        
        pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        pdfView.backgroundColor = UIColor.white
        pdfView.displayMode = PDFDisplayMode.singlePage
        pdfView.autoScales = true
        
        self.view = pdfView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
