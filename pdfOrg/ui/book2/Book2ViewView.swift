//
//  Book2ViewView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.03.21.
//

import SwiftUI

struct Book2ViewView: View {
    @EnvironmentObject var ec : EnvironmentController
    @EnvironmentObject var ecb : EnvironmentControllerBook

    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
    private var songsInGig: FetchedResults<SongInGig>
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    @FetchRequest(sortDescriptors: [])
    private var songsFR: FetchedResults<Song>
    
    @State var book: Book
    @Binding var page: Int
    
    @Binding var song: Song?
    @Binding var updayitView: Bool
    @Binding var collections: Collections
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            PDFKitBookView(book: book, pageIndex: $page)
            VStack{
                if song != nil {
                    if song!.isFavorit {
                        Button(action: {
                            removeSongInFavoritGig()
                        }) {
                            Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemBlue)).padding().padding()
                        }
                    } else {
                        Button(action: {
                            addSongToFavoritGig()
                        }) {
                            Image(systemName: "star").foregroundColor(Color(UIColor.systemBlue)).padding().padding()
                        }
                    }
                } else {
                    Button(action: {
                        addSong()
                    }) {
                        Image(systemName: "plus.circle").foregroundColor(Color(UIColor.systemBlue)).padding().padding()
                    }
                    
                }
            }
            VStack{
                Spacer()
                HStack{
                    if page  > 1 - (Int(book.pageOfset ?? "0") ?? 0) {
                        Button(action: {
                            page = page - 1
                            getSong()
                        }) {
                            Image(systemName: "chevron.left").padding()
                        }
                    }
                    Spacer()
                    
                    Button(action: {
                        page = page + 1
                        getSong()
                    }) {
                        if updayitView {
                            Image(systemName: "chevron.right").padding()
                        } else {
                            Image(systemName: "chevron.right").padding()
                        }
                    }
                }
                Spacer()
            }
            VStack{
                Spacer()
                Text("\(String(page))").foregroundColor(Color(UIColor.systemGray)).padding().padding()
            }
        }.gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width <= 0 {
                            page = page + 1
                            getSong()
                            print("3")
                        }
                        if value.translation.width >= 0 {
                            if page > 0 - (Int(book.pageOfset ?? "0") ?? 0) {
                                page = page - 1
                                getSong()
                                print("4")
                            }
                        }
                    }))
        .onAppear{
            song = nil
            getSong()
        }
//        .onDisappear{
//            ec.updatAllTitelsView.toggle()
//        }
        .onTapGesture {
            ec.showingPopupAppSong = false
            ec.presentationModeBook = true
            ec.pageIndexString = String(page)
            ec.pageIndex = page
            ec.book = book
        }
    }
    
    private func addSong() {
        
        let newSong: Song = Song(context: viewContext)
        
        newSong.book = book
        newSong.startPage = String(page)
        newSong.endPage = String(page)
        newSong.id = UUID()
        newSong.isFavorit = false
        
        let titel = "page \(String(page))" // TODO: muss noch lokalisiert werden
        
        newSong.title = titel
        saveContext()
        
       
        updayitView.toggle()
     //   ec.updateGigInfoView.toggle()
        print("ec.updateGigInfoView")
        print(ec.updateGigInfoView)
        song = newSong
    
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
            
            if (song as! Song).startPage != (song as! Song).endPage && songFound == false {
                
                let startPage = Int((song as! Song).startPage!)
                let endPage = Int((song as! Song).endPage ?? (song as! Song).startPage!)
                let pageCount = endPage! - startPage!
                
                (0..<(pageCount + 1)).forEach { i in
                    if (startPage! + i) == page && songFound == false{
                        self.song = (song as! Song)
                        songFound = true
                        ecb.titelName = (song as! Song).title ?? "error_no Titel"
                        ecb.startPage = (song as! Song).startPage ?? "1"
                        ecb.endPage = (song as! Song).endPage ?? (song as! Song).startPage ?? "1"
                        ecb.label = (song as! Song).author ?? ""
                    } else if songFound == false {
                        self.song = nil
                        ecb.titelName = "Page \(page)"
                        ecb.startPage = "\(page)"
                        ecb.endPage = "\(page)"
                        ecb.label = ""
                    }
                }
            } else if songFound == false{
               if (song as! Song).startPage == String(page) {
                    self.song = (song as! Song)
                    songFound = true
                print("hallo du dar 89")
     //           ec.navigationLinkActive = true
                    ecb.titelName = (song as! Song).title ?? "error_no Titel"
                    ecb.startPage = (song as! Song).startPage ?? "1"
                    ecb.endPage = (song as! Song).endPage ?? (song as! Song).startPage ?? "1"
                    ecb.label = (song as! Song).author ?? ""
                } else {
                    print("hallo du dar 32")
                    self.song = nil
                   ecb.titelName = "Page \(page)"
                    ecb.startPage = "\(page)"
                    ecb.endPage = "\(page)"
                    ecb.label = ""
                }
            }
        }
    }
    
    func removeSongInFavoritGig() {
        
//        let gig = getFavoritGig()
//
//        songsInGig.forEach { songInGig in
//
//            if songInGig.song == song && songInGig.gig == gig {
//
//                gig.removeFromSongsInGig(songInGig)
//
//            }
//        }
//        renewPosition(songsInGig: gig.songsInGig!)
//        song?.isFavorit = false
//        saveContext()
//        updayitView.toggle()
        
        collections.removeFavorites(song: song!)
        song?.isFavorit = false
        saveContext()
        updayitView.toggle()
    //    ec.reload.toggle()
    //    print("\(ec.reload)")
    }
    
    func addSongToFavoritGig() {
        
  //      let _ = getFavoritGig()
//
//        let newSongInGig = SongInGig(context: viewContext)
//        newSongInGig.song = song
//
//        let position = gig.songsInGig!.count + 1
//
//        newSongInGig.position = Int64(position)
//
//        gig.addToSongsInGig(newSongInGig)
//        renewPosition(songsInGig: gig.songsInGig!)
        collections.addToFavorites(song: song!)
    //    ec.reload.toggle()
   //     print("\(ec.reload)")
        song?.isFavorit = true
        saveContext()
        updayitView.toggle()
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
