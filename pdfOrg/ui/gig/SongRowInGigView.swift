//
//  SongRowInGigView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 22.01.21.
//

import SwiftUI

struct SongRowInGigView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var song: Song
    @Binding var gig: Gig
    @Binding var updateView: Bool
 //   @State var songIsSelectet: Bool = false
    
    var body: some View {
        HStack{
            Text("\(song.title!)")
                .onTapGesture {
                    print("foo")
                }
            Spacer()
            if songIsSelectet() {
                
                Image(systemName: "checkmark.square").onTapGesture {
                    deleteSongToGig()
                }
//                Button(action: {
//                    deleteSongToGig()
//                }) {
//                    Image(systemName: "checkmark.square")
//                }
            } else {
                Image(systemName: "square").onTapGesture {
                    addSongToGig()
                }
                
//                Button(action: {
//                    print("addSongToGig()")
//                    addSongToGig()
//                }) {
//                    Image(systemName: "square")
//                }
            }
        }
    }
    
    func addSongToGig() {
        let newGigSong: SongInGig = SongInGig(context: viewContext)
        newGigSong.song = song
        
        let gigSongsCaunt = gig.songsInGig?.count
        
        newGigSong.position = Int64(gigSongsCaunt ?? 0) + 1
        
        gig.addToSongsInGig(newGigSong)
        saveContext()
    }
    
    func deleteSongToGig() {
        
        gig.songsInGig!.forEach { songInGig  in
            
            if (songInGig as AnyObject).song == song {
                
                let songInGigAs: SongInGig = songInGig as! SongInGig
                print("delit")
                gig.removeFromSongsInGig(songInGigAs)
                saveContext()
                updateView.toggle()
            }
        }
    }
    
    func songIsSelectet() -> Bool {
        
        var songIsSelectet: Bool = false
        
        gig.songsInGig!.forEach { songInGig  in
            
            if (songInGig as AnyObject).song == song {
                songIsSelectet = true
                print("ich war hier")
            }
        }
        return songIsSelectet
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
