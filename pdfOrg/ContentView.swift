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
        
        if ec.presentationMode == false && ec.presentationModeBook == false && ec.presentationModeGig == false{
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
        } else if ec.presentationMode == true {
            PresentationView(song: $ec.song, page: ec.song.startPage!)
        } else if ec.presentationModeBook == true {
            BookPresentationView()
        } else{
            GigPresentationView(song: ec.song, pageIndex: ec.pageIndexString, songInGig: ec.songInGig, gig: ec.gig)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
