//
//  Collections.swift
//  pdfOrg
//
//  Created by Carl Espeter on 26.02.21.
//

import Foundation
import SwiftUI
import CoreData

class Collections {
    
    private var gigs: FetchedResults<Gig>
    public var array: [Gig]
    private var viewContext: NSManagedObjectContext  {
        return PersistenceController.shared.container.viewContext
    }
    
   init(gigs: FetchedResults<Gig>) {
        
        self.gigs = gigs
        self.array = []
        
        gigs.forEach{ gig in
            array.append(gig)
        }
        array.sort {
            $0.title ?? "" < $1.title ?? ""
        }
    }
    
    func importCollection(url: URL, books: FetchedResults<Book>) -> [String]? {
        
        var txt = String()
        
        do{
            guard url.startAccessingSecurityScopedResource() else {
                return nil
            }
            txt = try NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) as String
        }  catch {
            print(error)
        }
        
        var position: Int64 = 0
        var importetSongs: [(teitel: String,bookId: String)] = []
        var titel: String = ""
        
        txt.enumerateLines(invoking: { (line, stop) -> () in
            let lineSplit = line.components(separatedBy:";")
            
            if lineSplit.count == 1 {
                titel = lineSplit[0]
            } else {
                importetSongs.append((teitel: lineSplit[0], bookId: lineSplit[1]))
            }
        })
        
        let allNonExistentBooks  = allBooksExist(importetSongs, books: books)
        
        if allNonExistentBooks == nil {
            let newGig = Gig(context: viewContext)
            newGig.title = titel
            importetSongs.forEach { importetSong in
                newGig.addToSongsInGig(importSongsInGig(position: position, songTeitel: importetSong.teitel, bookId:  importetSong.bookId, books: books))
                position = position + 1
            }
            newGig.id = UUID()
            saveContext()
            
            array.append(newGig)
            
        //    gig = newGig //TODO: muss noch geamcg werden oder auch nicht
        } else {
         //   notExistingBooks =
            return allNonExistentBooks!
  //          bookAlert.toggle()
        }

        url.stopAccessingSecurityScopedResource()
        return nil
    }
    
    private func importSongsInGig(position: Int64, songTeitel: String, bookId: String, books: FetchedResults<Book>) -> SongInGig {
        
        let newSongInGig = SongInGig(context: viewContext)
        
        newSongInGig.position = Int64(position)
        
        books.forEach{ book in
            
            if book.id == bookId {
                
                let songsInGig = book.songs!.allObjects as! [Song]
                
                let sortedSongsInGig = songsInGig.sorted {
                    $0.title! < $1.title!
                }
  
                sortedSongsInGig.forEach{ song in
                    
                    if song.title == songTeitel {
                        newSongInGig.song = song
                    }
                }
            }
        }
        
        if newSongInGig.song == nil {
            
            newSongInGig.song = get404Song(teitel: songTeitel, books: books)
        }
        return newSongInGig
    }
    
    private func get404Song(teitel: String,  books: FetchedResults<Book>) -> Song {
        
        
        let gBookID = "supergeheimmesBuchDasNurIchKennenDarf42MahahahahahahaGeheim"
        
        var gBookExist: Bool = false
        var gBook: Book = Book()
        var gSong: Song = Song()
        
        books.forEach { book in
            
            if gBookID == book.id {
                gBookExist = true
                gBook = book
            }
        }
        
        if gBookExist{
            
            let songs = gBook.songs!.allObjects as! [Song]
            gSong = songs.first!
            
        } else {
            
            guard let asset = NSDataAsset(name: "404Book") else {
                fatalError("Missing data asset: 404Book")
            }
            
            let newBook = Book(context: viewContext)
            newBook.title = "404 Book"
            newBook.id = gBookID
            newBook.pdf = asset.data
            newBook.isLandscape = 0
            newBook.pageOfset = "0"
            
            
            let newSong = Song(context: viewContext)
            newSong.startPage = "1"
            newSong.endPage = "1"
            newSong.isFavorit = false
            newSong.id = UUID()
            newSong.title = "404"
            
            newBook.addToSongs(newSong)
            gSong = newSong
            saveContext()
        }
        return gSong
    }
    
   private func allBooksExist(_ importetSongs: [(teitel: String, bookId: String)],books: FetchedResults<Book>) -> [String]? {
        
        var allBooksExist: [String]?
        
        importetSongs.forEach { importetSong in
            
            var thsBookExist = false
            
            books.forEach { book in
                
                if importetSong.bookId == book.id {
                    thsBookExist = true
                }
            }
            if !thsBookExist {
                
                if allBooksExist == nil {
                    allBooksExist = []
                }
                
                allBooksExist!.append(importetSong.bookId)
            }
        }
        return allBooksExist
    }

    
    func addToFavorites(song: Song) {
        
        let favorit = get(collection: "Favorites")
        
        if favorit.title ==  "Favorites" {
            
            let newSongInGig = SongInGig(context: viewContext)
            
            newSongInGig.song = song
            newSongInGig.position = Int64(favorit.songsInGig?.count ?? 1) + 1
            
            favorit.addToSongsInGig(newSongInGig)
            
            song.isFavorit = true
            
        } else {
            let newGig = Gig(context: viewContext)
            newGig.title = "Favorites"
            array.append(newGig)
            addToFavorites(song: song)
        }
        saveContext()
    }
    
    func removeFavorites(song: Song) {
        
        let favoritGig = get(collection: "Favorites")
        
        let favoritCollection = Collection(gig: favoritGig)
        
        
        favoritCollection.titelsInCollection.forEach{ songInGig in
            
            if songInGig.song == song {
                favoritGig.removeFromSongsInGig(songInGig)
                song.isFavorit = false
                
            }
        }
        favoritCollection.renewPosition()
        saveContext()
    }
    

    
    func get(collection: String) -> Gig {
        
        var soughtGig = Gig()
        
        array.forEach{ gig in
            if gig.title == collection {
                soughtGig = gig
            }
        }
        return soughtGig
    }
    
    func delete(gig: Gig) {
       
        var i = 0
        var j = 0
        
        array.forEach{ collection in
            if collection == gig {
                j = i
            }
            i = i + 1
        }
        
        array.remove(at: j)
        viewContext.delete(gig)
        saveContext()
    }
    
    func addCollection(title: String, titelsInCollection: [SongInGig]){
        
        let newCollection: Gig = Gig(context: viewContext)
        newCollection.id = UUID()
        
        if title == "" {
            newCollection.title = "LS_new Collection" 
        } else {
            newCollection.title = title
        }
        
        titelsInCollection.forEach{ titelInCollection in
            newCollection.addToSongsInGig(titelInCollection)
        }
        
        saveContext()
        array.append(newCollection)
    }
    
    
    
   private func getFavoritCollection(titles: [Song]) -> Gig {
        
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
            
            titles.forEach { song in
                
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
    
    func delete(offsets: IndexSet) {
        offsets.map {array[$0]}.forEach(viewContext.delete)
        saveContext()
    }
    
    private func saveContext() {
        do{
            try viewContext.save()
        }
        catch {
            let error = error as NSError
            fatalError("error addBook: \(error)")
        }
    }

    
}
