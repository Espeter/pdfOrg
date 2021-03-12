//
//  AllTitelsPDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 08.03.21.
//

import SwiftUI

struct AllTitelsPDFView: View {
    @EnvironmentObject var ec : EnvironmentController
     
    @Binding var song: Song
    @Binding var pageIndex: String
    
    @Binding var collections: Collections
    @Binding var reload: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            PDFKitCampireView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $pageIndex, presentationModde: true)
            VStack{
                if song.isFavorit {
                    Button(action: {
                        removeFavorit()
                    }) {
                        Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemBlue)).padding().padding()
                    }
                } else {
                    Button(action: {
                        addToFavorit()
                    }) {
                        Image(systemName: "star").foregroundColor(Color(UIColor.systemBlue)).padding().padding()
                    }
                }
            }
            VStack{
                Spacer()
            HStack{
                
                if chevronLeftIsVisible() {
                    Button(action: {backPage()}, label: {
                        Image(systemName: "chevron.left").font(.title2).padding()
                    })
                }
                Spacer()
                if reload {
                    Text("")
                } else {
                    Text("")
                }
                if chevronRightIsVisible(){
                    Button(action: {nextPage()}, label: {
                        Image(systemName: "chevron.right").font(.title2).padding()
                    })
                    
                }
            }
                Spacer()
            }
        }.gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width <= 0 && chevronRightIsVisible() {
                            nextPage()
                        }
                        if value.translation.width >= 0 && chevronLeftIsVisible(){
                            backPage()                        }
                    }))
        .onTapGesture {
            ec.song = song
            ec.presentationMode = true
        }
    }
    
    private func removeFavorit(){
        
       
        
  
        collections.removeFavorites(song: song)
        
      
        reload.toggle()
    }
    
    private func addToFavorit(){
        collections.addToFavorites(song: song)
        reload.toggle()
    }
  
    func backPage() {
        
        var nextPage = Int(pageIndex) ?? 1
          nextPage = nextPage - 1
          pageIndex = String(nextPage)
    }
    
    func nextPage() {
        
      var nextPage = Int(pageIndex) ?? 1
        nextPage = nextPage + 1
        pageIndex = String(nextPage)
    }
    
    func chevronLeftIsVisible() -> Bool {
        
        var isVisible: Bool = true
        
        if pageIndex == song.startPage {
            isVisible  = false
        }
        return isVisible
    }
    
    func chevronRightIsVisible() -> Bool {
        
        var isVisible: Bool = true
        
        if pageIndex == song.endPage {
            isVisible  = false
        }
        return isVisible
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
