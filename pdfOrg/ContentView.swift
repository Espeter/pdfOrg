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
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [])
    private var songsFR: FetchedResults<Song>
    
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    
    var body: some View {
        
        if ec.presentationMode == false && ec.presentationModeBook == false && ec.presentationModeGig == false{
        TabView(selection: $ec.tabTag){
            LibraryView()
                .tabItem {
                    Image(systemName: "books.vertical")
                }.tag(1)
                
            GigView(gig: getFavoritGig())
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
    
    func getFavoritGig() -> Gig {
        
        var favoritGig: Gig? = nil
        
        gigs.forEach{ gig in
            if gig.title == "Favorits" {
                favoritGig = gig
            }
        }
        
        if favoritGig == nil {
            
            
            let newFavoritGig = Gig(context: viewContext)
            newFavoritGig.title = "Favorits"
            var i = 0
            
            getArraySong().forEach { song in
                
                if song.isFavorit {
                    
                    let songInGig = SongInGig(context: viewContext)
                    songInGig.position = Int64(i)
                    songInGig.song = song
                    
                    newFavoritGig.addToSongsInGig(songInGig)
                    i = i + 1
                }
            }
            favoritGig = newFavoritGig
        }
        
        return favoritGig!
    }
    
    func getArraySong() -> [Song] {
        var songsArray: [Song] = []
        
        songsFR.forEach{ song in
            songsArray.append(song)
        }
        
        songsArray.sort {
            $0.title! < $1.title!
        }
        return songsArray
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
