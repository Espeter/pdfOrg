//
//  ContentView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    var body: some View {
        ContentView2(collections: Collections(gigs: gigs))
        
    }
}

struct ContentView2: View {
    
    @EnvironmentObject var ec : EnvironmentController
    @EnvironmentObject var ecl : EnvironmentControllerLibrary
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var songsFR: FetchedResults<Song>
    
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    
    @FetchRequest(sortDescriptors: [])
    var books: FetchedResults<Book>
    
  //  @State var upDaedCollection: Bool = false
 
    @State var collections: Collections
    
    var body: some View {
        
        if ec.presentationMode == false && ec.presentationModeBook == false && ec.presentationModeGig == false {
            TabView(selection: $ec.tabTag){
                if ec.updatLibrary {
                    LibraryView(allLabels: getAllLabels(), segmentBooksByLabel: getSegmentBooksByLabel(), collections: $collections)
                        .tabItem {
                            Text("LS_Library" as LocalizedStringKey)
                            Image(systemName: "books.vertical")
                        }.tag(1)
                } else {
                    LibraryView(allLabels: getAllLabels(), segmentBooksByLabel: getSegmentBooksByLabel(), collections: $collections)
                        .tabItem {
                            Text("LS_Library" as LocalizedStringKey)
                            Image(systemName: "books.vertical")
                        }.tag(1)
                }
//                CampfireView()
//                    .tabItem{
//                        Image(systemName: "list.bullet")
//                    }.tag(2)
//
//                GigView(gig: getFavoritGig())
//                    .tabItem {
//                        Image(systemName: "doc.text")
//                    }.tag(3)
                if songsFR.count > 0 {
                    CollectionNavigationView(collections: collections, faworitenGig: collections.get(collection: "Favorites"), titles: Titles(songs: songsFR))
                    .tabItem {
                        Image(systemName: "doc.text")
                        Text("LS_collection" as LocalizedStringKey)
                    }.tag(4)
                }
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
        print("1getFavoritGig()")
        var favoritGig: Gig? = nil
        
        gigs.forEach{ gig in
            if gig.title == "Favorites" {
                favoritGig = gig
            }
        }
        
        if favoritGig == nil {
            
            
            let newFavoritGig = Gig(context: viewContext)
            newFavoritGig.title = "Favorites"
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
        print("1getArraySong()")
        songsFR.forEach{ song in
            songsArray.append(song)
        }
        
        songsArray.sort {
            $0.title! < $1.title!
        }
        return songsArray
    }
    
    func getAllLabels() -> [String] {
        print("1getAllLabels()")
        var allLabels: [String] = []
        
        allLabels.append("")
        
        getBooksAlphabetical().forEach{ book in
            
            if !allLabels.contains(book.label ?? "") {
                
                allLabels.append(book.label ?? "")
            }
        }
        
        allLabels.sort {
            $0 < $1
        }
        
        print("allLabels: \(allLabels)")
        return allLabels
    }
    
    func getSegmentBooksByLabel() -> [String: [Book]] {
        print("1getSegmentBooksByLabel()")
        var dictionary: [String: [Book]] = [:]
        
        getAllLabels().forEach{ label in
            dictionary[label] = []
        }
        
        
        
        getBooksAlphabetical().forEach{ book in
            
            let bookLabel = book.label
            if book.id != ec.gBookID {
                dictionary[bookLabel ?? ""]?.append(book)
            }
        }
        
//        if dictionary["-"] == nil {
//            dictionary["-"] = []
//        }
        
        return dictionary
    }
    

    
    
    
    func getBooksAlphabetical() -> [Book] {
        print("1getBooksAlphabetical()")
        var booksAlphabetical: [Book] = []
        
        books.forEach{ book in
            booksAlphabetical.append(book)
        }
        
        booksAlphabetical.sort{
            $0.title! < $1.title!
        }
        return booksAlphabetical
    }
}
