//
//  BookPDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookPDFView: View {
    
    @EnvironmentObject var ec : EnvironmentController
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var songsFR: FetchedResults<Song>
    
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    
    @FetchRequest(sortDescriptors: [])
    private var songsInGig: FetchedResults<SongInGig>

    @State var book: Book
    @Binding var song: Song?
    @Binding var updateView: Bool
    @Binding var infoPopup: Bool
    @Binding var showingPopup: Bool
    
    @Binding var page: Int
    
    var body: some View {
        HStack() {
            Button(action: {
                if page > 0 {
                    page = page - 1
                    getSong()
                }
            }) {
          //      Image(systemName: "lessthan")
                Image(systemName: "chevron.left").padding()
            }
            ZStack(alignment: .topTrailing) {
            PDFKitBookView(book: book, pageIndex: $page)//.frame(width: 300, height: 380.5)
                .onTapGesture {
                    infoPopup = false
                    ec.showingPopupAppSong = false
                    showingPopup = false
                    ec.presentationModeBook = true
                    ec.pageIndexString = String(page)
                    ec.pageIndex = page
                    ec.book = book
                    
                    
                    print(" ec.showingPopupAppSong: \( ec.showingPopupAppSong)")
                    print("showingPopup: \(showingPopup)")
                }
                if song != nil {
                    if song!.isFavorit {
                        Button(action: {
                            song!.isFavorit = false
                            
                          
                            removeSongInFavoritGig()
                            
                            saveContext()
                            updateView.toggle()
                            ec.updateGigInfoView.toggle()

                        }) {
                            
                            if updateView {
                                Text("")
                            }
                            
                            Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                        }
                    } else {
                        Button(action: {
                            song!.isFavorit = true
                            addSongToFavoritGig()
                            saveContext()
                            updateView.toggle()
                            ec.updateGigInfoView.toggle()

                        }) {
                            Image(systemName: "star").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                        }
                    }
                }
            }
            Button(action: {
                page = page + 1
                getSong()
            }) {
         //       Image(systemName: "greaterthan")
                Image(systemName: "chevron.right").padding()
            }
        }
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
        .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width <= 0 {
                            page = page + 1
                            getSong()
                        }
                        if value.translation.width >= 0 {
                            if page > 0 {
                                page = page - 1
                                getSong()
                            }
                        }
                    }))
    }
    
    private func saveContext(){
        do{
            try viewContext.save()
        }
        catch {
            let error = error as NSError
            fatalError("error addBook: \(error)")
        }
    }
    
    func getSong() {
        
        let songs = book.songs
        var songFound = false
        songs?.forEach { song in
            
            if (song as! Song).startPage != (song as! Song).endPage && songFound == false{
                
                let startPage = Int((song as! Song).startPage!)
                let endPage = Int((song as! Song).endPage ?? (song as! Song).startPage!)
                let pageCount = endPage! - startPage!
                
                (0..<(pageCount + 1)).forEach { i in
                    if (startPage! + i) == page && songFound == false{
                        self.song = (song as! Song)
                        songFound = true
                        print("songFound \(songFound)")
                    } else if songFound == false {
                        self.song = nil
                    }
                }
            } else if songFound == false{
                if (song as! Song).startPage == String(page) {
                    self.song = (song as! Song)
                    print("songFound2 true")
                } else {
                    self.song = nil
                }
            }
        }
    }
    
    
    func removeSongInFavoritGig() {
        
        let gig = getFavoritGig()
        
        songsInGig.forEach { songInGig in
            
            if songInGig.song == song && songInGig.gig == gig {
                
                gig.removeFromSongsInGig(songInGig)
                
            }
        }
        renewPosition(songsInGig: gig.songsInGig!)
        saveContext()
    }
    
    func addSongToFavoritGig() {
        
        let gig = getFavoritGig()
        
        let newSongInGig = SongInGig(context: viewContext)
        newSongInGig.song = song

        let position = gig.songsInGig!.count + 1
        
        newSongInGig.position = Int64(position)
        
        gig.addToSongsInGig(newSongInGig)
        renewPosition(songsInGig: gig.songsInGig!)
        saveContext()
    }
    
    
    func getFavoritGig() -> Gig {
        
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
        
        songsFR.forEach{ song in
            songsArray.append(song)
        }
        
        songsArray.sort {
            $0.title! < $1.title!
        }
        return songsArray
    }
    
    func renewPosition(songsInGig: NSSet) {
        
        var i = 0
        
        songsInGig.forEach{ songInGig in
            
            (songInGig as! SongInGig).position = Int64(i)
            i = i + 1
        }
    }
    
}
