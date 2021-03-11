//
//  Collection.swift
//  pdfOrg
//
//  Created by Carl Espeter on 04.03.21.
//

import Foundation
import SwiftUI
import CoreData

class Collection {
    
    public var gig: Gig
    public var titels: [Song]
    public var titelsInCollection: [SongInGig]
    public var name: String
    private var viewContext: NSManagedObjectContext  {
        return PersistenceController.shared.container.viewContext
    }
    
   init(gig: Gig) {
        
        self.gig = gig
        self.titels = []
        self.titelsInCollection = []
        self.name = gig.title ?? "error_no gig titel"
    
    gig.songsInGig?.forEach{ songInGig in
        self.titelsInCollection.append(songInGig as! SongInGig)
    }
    
    titelsInCollection = titelsInCollection.sorted {
        $0.position < $1.position
    }
    
    titelsInCollection.forEach{ songingig in
        titels.append(songingig.song!)
    }
    }
    
//    func getSongsCopy() -> [SongInGig] {
//        
//        var copy: [SongInGig] = []
//        var i = 0
//        var songs: [Song] = []
//        titelsInCollection.forEach{ songingig in
//            print(i)
//            i = i + 1
//            let newSongingig = SongInGig(context: viewContext)
//            newSongingig.position = songingig.position
//         //   newSongingig.bookId =  songingig.song?.book?.id
//       //     newSongingig.teitel = songingig.song?.title
//   //         newSongingig.song = songingig.song
//            songs.append(songingig.song!)
//            copy.append(newSongingig)
//        }
//        var y = 0
//        copy.forEach{ songingig in
//       //     songingig.song = songs[y]
//           y = y + 1
//        }
//        
//        
////        copy = copy.sorted {
////            $0.position < $1.position
////        }
//        return copy
//    }
    
    func save(newName: String?) {
        
        if newName != nil && newName != "" {
            gig.title = newName
            name = newName ?? "error_no Name"
        }
        
        gig.songsInGig = NSSet()
        titels = []
        
        titelsInCollection.forEach{ titelInCollection in
            
            gig.addToSongsInGig(titelInCollection)
            titels.append(titelInCollection.song!)
        }
        saveContext()
    }
    
    func quit(copyOftitelsInCollection copy: [SongInGig]) {
        
        name = gig.title ?? "error_no gig titel"
        titelsInCollection = copy

        titelsInCollection = titelsInCollection.sorted {
            $0.position < $1.position
        }
        viewContext.rollback()
    }
    
    
    func getTxet() -> String {
        
        var txt: String
        
        txt = "\(String(describing: gig.title!))\n"
        
        titelsInCollection.forEach { songInGig in
            
            let title = String((songInGig.song?.title)!)
            let id = String((songInGig.song?.book?.id)!)
            
            txt = txt + "\(title);\(id)\n"
        }
        return txt
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
