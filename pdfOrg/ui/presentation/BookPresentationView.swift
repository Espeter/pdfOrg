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
    @State var isLandscape = true
        
        var body: some View {
            NavigationView(){
                ZStack(alignment: .topTrailing){
                    PDFPresentationView(book: $ec.book, pageIndex: $ec.pageIndexString, isLandscape: $isLandscape)
                        .navigationBarTitle("\(ec.book.title!)", displayMode: .inline)
                        .navigationBarItems(leading:
                                                HStack{
                                                    Button(action: {
                                                        ec.presentationModeBook = false
                                                    }) {
                                                        HStack{
                                                       //     Image(systemName: "lessthan")
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
                        ec.presentationModeBook = false
                    }) {
                        Image(systemName:"multiply").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                    }
                }
                .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                            .onEnded({ value in
                                if value.translation.width <= 0 {
                                    ec.pageIndex = ec.pageIndex + visiblePages()
                                    ec.pageIndexString = String(ec.pageIndex)
                                }
                                if value.translation.width >= 0 {
                                    ec.pageIndex = ec.pageIndex - visiblePages()
                                    ec.pageIndexString = String(ec.pageIndex)
                                }
                            }))
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    
    func visiblePages() -> Int {
        
        var visiblePages: Int
        if ec.book.isLandscape == 1 {
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
    
        func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
            return Binding(get: {
                binding.wrappedValue ?? fallback
            }, set: {
                binding.wrappedValue = $0
            })
        }
    }
