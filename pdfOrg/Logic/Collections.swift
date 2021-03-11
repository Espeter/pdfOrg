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
    
    func getFavoritCollection(titles: [Song]) -> Gig {
        
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
