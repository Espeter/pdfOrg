//
//  PresentationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 17.01.21.
//

import SwiftUI

struct PresentationView: View {
    
    @EnvironmentObject var ec : EnvironmentController
    
    @Binding var song: Song
    @State var page: String
    @State var navigationBarHidden = true
    @State var isLandscape: Bool = true
    
    var body: some View {
        NavigationView(){
            ZStack(alignment: .topTrailing){
                PDFPresentationView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $page, isLandscape: $isLandscape)
                    .navigationBarTitle("\(song.title!)", displayMode: .inline)
                    .navigationBarItems(leading:
                                            HStack{
                                                Button(action: {
                                                    ec.presentationMode = false
                                                }) {
                                                    HStack{
                                                      //  Image(systemName: "lessthan")
                                                        Image(systemName: "chevron.left")
                                                        Text("back")
                                                    }
                                                }
                                            }
                    )
                    .navigationBarHidden(navigationBarHidden)
                    .onTapGesture {
                        navigationBarHidden.toggle()
                    }
                Button(action: {
                    ec.presentationMode = false
                }) {
                    Image(systemName:"multiply").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                }
            }
            .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.width <= 0 {
                                nextPage()
                            }
                            if value.translation.width >= 0 {
                                backPage()                        }
                        }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func visiblePages() -> Int {
        
        var visiblePages: Int
        if song.book?.isLandscape == 1 {
            visiblePages = 1
        } else {
            if isLandscape {
                visiblePages = 2
            } else {
                visiblePages = 1
            }
        }
        return visiblePages
    }
    
    func nextPage() {
        var IntPageIndex = Int(page)!
        let IntEndPage = Int(song.endPage ?? "1")!
        
        if IntPageIndex < (IntEndPage + 1 - visiblePages()) {
            IntPageIndex = IntPageIndex + visiblePages()
            page = String(IntPageIndex)
        }
    }
    
    func backPage() {
        var IntPageIndex = Int(page)!
        let IntStartPage = Int(song.startPage ?? "1")!
        
        if IntPageIndex > IntStartPage {        // TODO: past das?????? oder muss es wie in nextPage()
            IntPageIndex = IntPageIndex - visiblePages()
            page = String(IntPageIndex)
        }
    }
    
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
}
