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
    @State var navigationBarHidden = true
    
    var body: some View {
        NavigationView(){
            ZStack(alignment: .topTrailing){
                PDFKitCampireView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: umwantler(binding: $song.startPage,fallback: "1"), presentationModde: true)
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
}
