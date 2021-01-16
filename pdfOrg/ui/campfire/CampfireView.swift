//
//  CampfireView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 16.01.21.
//

import SwiftUI

struct CampfireView: View {
    
    @State var song: Song?
    @State var i: Int = 3

    
    var body: some View {
        HStack{
            VStack{
                Text("Info")
                if song != nil {
                    BookPDFView(book: (song?.book)!, page: $i)
                } else {
                    Text("pdf")
                }
            }
            AllSongsView(song: $song).padding()
        }
        .background(Color(UIColor.systemBlue).opacity(0.05))
    }
}

struct CampfireView_Previews: PreviewProvider {
    static var previews: some View {
        CampfireView()
    }
}
