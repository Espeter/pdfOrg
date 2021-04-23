//
//  AllTitelsView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 08.03.21.
//

import SwiftUI

struct AllTitelsView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    @EnvironmentObject var orientationInfo: OrientationInfo

    @State var tilels: Titles
    
    @State var selectedTitel: Song
    @State var pageIndex: String = "1"
    var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    @Binding var collections: Collections

    @Binding var reload: Bool// = false

    var body: some View {
        GeometryReader { geometry in
            
            
           // if geometry.size.width > geometry.size.height {
            if orientationInfo.orientation == .landscape {
                HStack{
                    AllTitelsPDFView(song: $selectedTitel, pageIndex: $pageIndex, collections: $collections, reload: $reload)
                    AllTitelsLiestView(selectedTitel: $selectedTitel, pageIndex: $pageIndex/*, segmentTitels: tilels.getSegmentTitles(by: alphabet, songs: songs)*/, titels: $tilels, reload: $reload)
                }
            } else {
                VStack{
                    AllTitelsPDFView(song: $selectedTitel, pageIndex: $pageIndex, collections: $collections, reload: $reload)
                    AllTitelsLiestView(selectedTitel: $selectedTitel, pageIndex: $pageIndex/*, segmentTitels: tilels.getSegmentTitles(by: alphabet, songs: songs)*/, titels: $tilels, reload: $reload)
                }
            }
        }
        
        .navigationBarTitle("LS_All Titels" as LocalizedStringKey)
        .onAppear{
            pageIndex = selectedTitel.startPage ?? "1"
        }
    }
}
