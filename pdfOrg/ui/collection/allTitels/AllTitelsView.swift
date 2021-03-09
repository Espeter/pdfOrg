//
//  AllTitelsView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 08.03.21.
//

import SwiftUI

struct AllTitelsView: View {
    
    
    
    @State var tilels: Titles
    
    @State var selectedTitel: Song
    @State var pageIndex: String = "1"
    var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    
    
    var body: some View {
        GeometryReader { geometry in
            
            
            if geometry.size.width > geometry.size.height {
                HStack{
                    
                    AllTitelsPDFView(song: $selectedTitel, pageIndex: $pageIndex)
                    
                    AllTitelsLiestView(selectedTitel: $selectedTitel, pageIndex: $pageIndex, segmentTitels: tilels.getSegmentTitles(by: alphabet), titels: tilels)
                }
            } else {
                VStack{
                    
                    AllTitelsPDFView(song: $selectedTitel, pageIndex: $pageIndex)
                    
                    AllTitelsLiestView(selectedTitel: $selectedTitel, pageIndex: $pageIndex, segmentTitels: tilels.getSegmentTitles(by: alphabet), titels: tilels)
                }
            }
        }
        .navigationBarTitle("LS_All Titels" as LocalizedStringKey)
        .onAppear{
            
            pageIndex = selectedTitel.startPage ?? "1"
            
        }
    }
}
