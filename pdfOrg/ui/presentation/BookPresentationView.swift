//
//  BookPresentationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 18.01.21.
//

import SwiftUI

struct BookPresentationView: View {
        
        @EnvironmentObject var ec : EnvironmentController
        
        @State var navigationBarHidden = true
        
        var body: some View {
            NavigationView(){
                ZStack(alignment: .topTrailing){
                    PDFKitBookPresentationView(book: $ec.book, pageIndex: $ec.pageIndex, presentationModde: true)
                        .navigationBarTitle("\(ec.book.title!)", displayMode: .inline)
                        .navigationBarItems(leading:
                                                HStack{
                                                    Button(action: {
                                                        ec.presentationModeBook = false
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
                        ec.presentationModeBook = false
                    }) {
                        Image(systemName:"multiply").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                    }
                }
                .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                            .onEnded({ value in
                                if value.translation.width <= 0 {
                                    ec.pageIndex = ec.pageIndex + 2
                                }
                                if value.translation.width >= 0 {
                                    ec.pageIndex = ec.pageIndex - 2
                                }
                            }))
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
