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
    
    var body: some View {
        NavigationView(){
            ZStack(alignment: .topTrailing){
                PDFKitCampireView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $page, presentationModde: true)
                    .navigationBarTitle("\(song.title!)", displayMode: .inline)
                    .navigationBarItems(leading:
                                            HStack{
                                                Button(action: {
                                                    ec.presentationMode = false
                                                }) {
                                                    HStack{
                                                        Image(systemName: "lessthan")
                                                        Text("Back")
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
    
    func nextPage() {
        var IntPageIndex = Int(page)!
        let IntEndPage = Int(song.endPage ?? "1")!
        
        if IntPageIndex < IntEndPage {
            IntPageIndex = IntPageIndex + 1
            page = String(IntPageIndex)
        }
    }
    
    func backPage() {
        var IntPageIndex = Int(page)!
        let IntStartPage = Int(song.startPage ?? "1")!
        
        if IntPageIndex > IntStartPage {
            IntPageIndex = IntPageIndex - 1
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
