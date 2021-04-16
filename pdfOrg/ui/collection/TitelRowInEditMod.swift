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
    
    @Binding var reload: Bool
    
//    private var titel: String?
//    private var author: String?
//    private var boolTitel: String?
    
    @State private var is404: Bool = false
    
    var body: some View {
        
        HStack{
            
            if titelInColetion.song != nil {
       //     Text("\(titelInColetion.position).").font(.title3)//.padding()
                Text("\(getPosion()).").font(.title3)//.padding()
            VStack(alignment: .leading){
                HStack{
                    Text(titelInColetion.song!.title ?? "error_no Titel")
                    if titelInColetion.song!.isFavorit {
                        Image(systemName: "star.fill").padding(.leading, 10)
                    }
                    if is404 {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color(UIColor.systemYellow)).padding(.leading, 10)
                    }
                    if reload {
                        Text("")
                    } else {
                        Text("")
                    }
                }//.font(.title3)
                HStack{
                    if is404 {
                        Text("LS_This Teitel is not faund in Book" as LocalizedStringKey).foregroundColor(Color(UIColor.systemGray))
                    } else {
                        Text(titelInColetion.song!.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
                    }
                    Spacer()
                    Text(titelInColetion.song!.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                }.font(.footnote)
            }
            Image(systemName: "line.horizontal.3").font(.title3).foregroundColor(Color(UIColor.systemGray)).padding()
        }
        }
        .onAppear(){
            
            if songNotFaund() {
                is404 = true
            }
        }
    }
    
    private func getPosion() -> String {    // TODO: bauche ich das überhopt?
        
        var posisheen: String = "1"
        titelsInColetion.forEach { song in
          
            if song == titelInColetion {
              
                posisheen = String(Int(song.position))
        }
        }
        return posisheen
    }
    
    
    private func songNotFaund() -> Bool {
        
        var is404: Bool = false
        
        if titelInColetion.song?.book?.id == "supergeheimmesBuchDasNurIchKennenDarf42MahahahahahahaGeheim" {
            is404 = true
        }
        return is404
    }
}
