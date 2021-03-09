//
//  TitelRowInEditMod.swift
//  pdfOrg
//
//  Created by Carl Espeter on 03.03.21.
//

import SwiftUI

struct TitelRowInEditMod: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var titelInColetion: SongInGig
    @Binding var titelsInColetion: [SongInGig]
    
    var body: some View {
        
        HStack{
            
            if titelInColetion.song != nil {
            Text("\(titelInColetion.position).").font(.title3)//.padding()
            
            VStack(alignment: .leading){
                HStack{
                    Text(titelInColetion.song!.title ?? "error_no Titel")
                    if titelInColetion.song!.isFavorit {
                        Image(systemName: "star.fill").padding(.leading, 10)
                    }
                }//.font(.title3)
                HStack{
                    Text(titelInColetion.song!.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
                    Spacer()
                    Text(titelInColetion.song!.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                }.font(.footnote)
            }
            Image(systemName: "line.horizontal.3").font(.title3).foregroundColor(Color(UIColor.systemGray)).padding()
        }
        }
    }
}
