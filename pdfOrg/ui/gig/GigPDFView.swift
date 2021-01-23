//
//  GigPDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 23.01.21.
//

import SwiftUI

struct GigPDFView: View {
    
    @Binding var songIsSelectet: Bool
    @Binding var gigSongIsSelectet: Bool
    @Binding var song: Song?
    @Binding var pageIndex: String
    @State var songInGig: SongInGig?
    
    var body: some View {
        VStack{
            if songIsSelectet {
                CampfirePDFView(song: umwantler(binding: $song, fallback: Song()), pageIndex: $pageIndex)
            } else if gigSongIsSelectet {
                Text("gigSongIsSelectet")
            } else {
                Text("selekt Song")
            }
        }
        .frame(minWidth: 300,
               idealWidth: .infinity,
               maxWidth: .infinity,
               minHeight: 380.5,
               idealHeight: .infinity,
               maxHeight: .infinity)
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
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

