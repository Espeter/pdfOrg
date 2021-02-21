//
//  GigInfoView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 21.01.21.
//

import SwiftUI

struct GigInfoView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var ec : EnvironmentController
    
    @FetchRequest(sortDescriptors: [])
    var books: FetchedResults<Book>
    
    @Binding var gig: Gig
    @Binding var updateView: Bool
    
    @Binding var songIsSelectet: Bool
    @Binding var gigSongIsSelectet: Bool
    @Binding var songInGig: SongInGig?
    @Binding var pageIndex: String
    @Binding var song: Song?
    
    
    var body: some View {
        
        List{
            ForEach(getArraySong(gig.songsInGig!)) { songinGig in
                
                Button(action: {
    
                        songIsSelectet = false
                        gigSongIsSelectet = true
                        pageIndex = (songinGig.song?.startPage)!
                        self.songInGig = songinGig
                        song = (songInGig?.song)!
                 
                }) {
                    HStack{
                        Text("\(songinGig.position + 1)")
                        if songinGig.teitel == nil {
                            Text("\(songinGig.song!.title!)")
                            Text("  ").foregroundColor(Color(UIColor.systemGray3))
                            Text("\(songinGig.song!.author ?? "-")")
                        } else {
                            Text("\(songinGig.teitel!)")
                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color(UIColor.yellow)).padding()
                            Text("song does not exist in the book with the id: \(songinGig.bookId!)")
                            Button(action: {findSongs()}, label: {
                                VStack{
                                    Image(systemName: "doc.text.magnifyingglass")
                                Text("search song")
                                }
                            })
                        }
                        
                        if updateView {
                            Text("").frame(width: 0, height: 0)
                        }
                        if ec.updateGigInfoView {
                            Text("").frame(width: 0, height: 0)
                        }
                    }
                }
            }.onDelete(perform: deleteSong)
            .onMove(perform: move)
            
        }.padding().background(Color(UIColor.white)).cornerRadius(15.0).shadow( radius: 15, x: 3, y: 5)
    }
    
    
    func findSongs() {
        
        var unassignedSongs: [SongInGig] = []
        
        getArraySong(gig.songsInGig!).forEach{ songInGig in
            
            if songInGig.teitel != nil {
                unassignedSongs.append(songInGig)
            }
        }
        
        unassignedSongs.forEach{ unassignedSong in
            
            books.forEach { book in
                
                if book.id == unassignedSong.bookId {
                 
                    let songs = book.songs!.allObjects as! [Song]
                    
                    songs.forEach{ song in
                        
                        if song.title == unassignedSong.teitel {
                            unassignedSong.song = song
                            unassignedSong.teitel = nil
                            unassignedSong.bookId = nil
                        }
                    }
                    
                }
            }
        }
        updateView.toggle()
        saveContext()
    }
    
    
    func move(from source: IndexSet, to destination: Int) {
        
        //  let source = source.first
        moveSongInGig(from: source.first!, to: destination)
        updateView.toggle()
    }
    
    func getArraySongInGig(_ snSet : NSSet) -> [SongInGig] {
        var songsInGig = snSet.allObjects as! [SongInGig]
        
        songsInGig.sort {
            //    $0.position > $1.position
            $0.position < $1.position
        }
        
        return songsInGig
    }
    
    func moveSongInGig(from source: Int, to destination: Int) {
        
        var songsInGig = getArraySongInGig(gig.songsInGig!)
        
        
        print("source: \(source) destination: \(destination)")
        
        var destinationNew = destination
        
        let element = songsInGig.remove(at: source)
        if destinationNew >= songsInGig.count {
            destinationNew = destination - 1
        }
        songsInGig.insert(element, at: destinationNew )
        
        renewPosition(songsInGig: songsInGig)
        print("moveSongInGig")
    }
    
    func renewPosition(songsInGig: [SongInGig]) {
        
        var i = 0
        
        songsInGig.forEach{ songInGig in
            
            songInGig.position = Int64(i)
            i = i + 1
        }
        saveContext()
        
        updateView.toggle()
    }
    
    private func deleteSong(offsets: IndexSet) {
        withAnimation {
            
            if gig.title == "Favorites" {
                offsets.map {getArraySong(gig.songsInGig!)[$0]}.first?.song?.isFavorit = false
            }
            offsets.map {getArraySong(gig.songsInGig!)[$0]}.forEach(viewContext.delete)
            renewPosition(songsInGig: getArraySongInGig(gig.songsInGig!))
            saveContext()
            updateView.toggle()
        }
    }
    
    func getArraySong(_ snSet : NSSet) -> [SongInGig] {
        
        let songsInGig = snSet.allObjects as! [SongInGig]
        
        let sortedSongsInGig = songsInGig.sorted {
            $0.position < $1.position
        }
        return sortedSongsInGig
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
