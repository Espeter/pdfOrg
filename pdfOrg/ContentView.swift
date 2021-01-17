//
//  ContentView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var ec : EnvironmentController
    
    var body: some View {
        
        if ec.presentationMode == false {
        TabView(selection: $ec.tabTag){
            LibraryView()
                .tabItem {
                    Image(systemName: "books.vertical")
                }.tag(1)
                
            GigView()
                .tabItem {
                    Image(systemName: "music.note.list")
                }.tag(2)
            CampfireView()
                .tabItem{
                    Image(systemName: "flame")
                }.tag(3)
        }
        } else {
            PresentationView(song: $ec.song)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
