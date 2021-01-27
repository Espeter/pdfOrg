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
    
    @Binding var songIsSelectet: Bool
    @Binding var gigSongIsSelectet: Bool
    @Binding var songSelectet: Song?
    @Binding var pageIndex: String

    
    var body: some View {
        HStack{
            
            if thsSongIsSelectet() {
                
                Image(systemName: "checkmark.square").foregroundColor(Color(UIColor.systemGray))
                    .onTapGesture {
                    deleteSongToGig()
                }
                
            } else {
                Image(systemName: "square").foregroundColor(Color(UIColor.systemGray))
                    .onTapGesture {
                    addSongToGig()
                }
            }
            Button(action: {
                print("\(song.title!)")
                gigSongIsSelectet = false
                songIsSelectet = true
                songSelectet = song
                pageIndex = song.startPage!
            }) {
                Text("\(song.title!)")
            }
            
            if updateView {
                Text("").frame(width: 0, height: 0)
            }
            
            Spacer()
            if song.isFavorit {
                Spacer()
                Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray))
            }
                
                //                Button(action: {
                //                    print("addSongToGig()")
                //                    addSongToGig()
                //                }) {
                //                    Image(systemName: "square")
                //                }
            
        }
    }
    
    func addSongToGig() {
        let newGigSong: SongInGig = SongInGig(context: viewContext)
        newGigSong.song = song
        renewPosition(songsInGig: gig.songsInGig!)

        let gigSongsCaunt = gig.songsInGig?.count
        
        newGigSong.position = Int64(gigSongsCaunt ?? 0) //+ 1
        
        gig.addToSongsInGig(newGigSong)
        updateView.toggle()
        saveContext()
    }
    
    func deleteSongToGig() {
        
        gig.songsInGig!.forEach { songInGig  in
            
            if (songInGig as AnyObject).song == song {
                
                let songInGigAs: SongInGig = songInGig as! SongInGig
                print("delit")
                gig.removeFromSongsInGig(songInGigAs)
                renewPosition(songsInGig: gig.songsInGig!)
                saveContext()
                updateView.toggle()
            }
        }
    }
    
    func renewPosition(songsInGig: NSSet) {
        
        var i = 0
        
        songsInGig.forEach{ songInGig in
            
            (songInGig as! SongInGig).position = Int64(i)
            i = i + 1
        }
        saveContext()
       
        updateView.toggle()
    }
    
    func thsSongIsSelectet() -> Bool {
        
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
