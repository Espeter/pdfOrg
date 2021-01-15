//
//  GigView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 15.01.21.
//

import SwiftUI

struct GigView: View {
    
    @State var showingSelectGigView: Bool = false
    @State var showingAddGigSongPopoverView: Bool = false

    @State var gig: Gig?
    
    var body: some View {
        
        NavigationView{
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading:
                                        HStack{
                                            Text("Gig: ")
                                            Button(action: {
                                                showingSelectGigView.toggle()
                                            }) {
                                                Text("\(gig?.title ?? "selector Gig")")
                                                    .popover(isPresented: self.$showingSelectGigView) {
                                                        SelectGigView(gig: $gig, showingPopup: $showingSelectGigView)
                                                    }
                                            }
                                        }
                                    
                                    ,trailing:
                                        HStack{
                                            Button(action: {
                                                showingAddGigSongPopoverView.toggle()
                                            }) {
                                                Image(systemName: "plus")
                                                    .popover(isPresented: self.$showingAddGigSongPopoverView) {
                                                        AddGigSongPopoverView()
                                                }
                                            }
                                        }
                )
                .background(Color(UIColor.systemBlue).opacity(0.05))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GigView_Previews: PreviewProvider {
    static var previews: some View {
        GigView()
    }
}
