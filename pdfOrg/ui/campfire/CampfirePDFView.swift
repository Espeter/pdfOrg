//
//  CampfirePDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 17.01.21.
//

import SwiftUI

struct CampfirePDFView: View {
        
    @EnvironmentObject var ec : EnvironmentController

    @Binding var song: Song
    
    var body: some View {
        VStack{
            if song.title != nil {
                PDFKitCampireView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: umwantler(binding: $song.startPage,fallback: "1"), presentationModde: true)
            } else {
                Text("selekt Song")
            }
        }.frame(width: 300, height: 380.5)
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
        .onTapGesture {
            ec.song = song
            ec.presentationMode = true
        }
        .shadow( radius: 15, x: 3, y: 5)
    }
    
    // Qelle: https://forums.swift.org/t/promoting-binding-value-to-binding-value/31055
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
}

