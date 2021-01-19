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
    @Binding var pageIndex: String
    
    var body: some View {
        VStack{
            if song.title != nil {
                if song.endPage != nil && song.endPage != song.startPage {
                    
                    HStack{
                        Button(action: {
                            print("back")
                            backPage()
                            print(pageIndex)
                        }) {
                            Image(systemName: "lessthan")
                        }
                        PDFKitCampireView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $pageIndex, presentationModde: true)
                        Button(action: {
                            print("nex")
                            nextPage()
                            print(pageIndex)
                        }) {
                            Image(systemName: "greaterthan")
                        }
                    }
                } else {
                    PDFKitCampireView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $pageIndex, presentationModde: true)
                }
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
        .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width <= 0 {
                            nextPage()
                        }
                        if value.translation.width >= 0 {
                            backPage()                        }
                    }))
        .shadow( radius: 15, x: 3, y: 5)
    }
    
    func nextPage() {
        var IntPageIndex = Int(pageIndex)!
        let IntEndPage = Int(song.endPage ?? "1")!
        
        if IntPageIndex < IntEndPage {
            IntPageIndex = IntPageIndex + 1
            pageIndex = String(IntPageIndex)
        }
    }
    
    func backPage() {
        var IntPageIndex = Int(pageIndex)!
        let IntStartPage = Int(song.startPage ?? "1")!
        
        if IntPageIndex > IntStartPage {
            IntPageIndex = IntPageIndex - 1
            pageIndex = String(IntPageIndex)
        }
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

