//
//  ContentView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        
        
        TabView{
            LibraryView()
                .tabItem {
                    Image(systemName: "books.vertical")
                }
                
            GigView()
                .tabItem {
                    Image(systemName: "music.note.list")
                }
            Text("all Songs")
                .tabItem{
                    Image(systemName: "play.circle")
                }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
