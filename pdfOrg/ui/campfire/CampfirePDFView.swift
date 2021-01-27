//
//  CampfirePDFView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 17.01.21.
//

import SwiftUI

struct CampfirePDFView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject var ec : EnvironmentController
    
    @FetchRequest(sortDescriptors: [])
    private var songsFR: FetchedResults<Song>
    
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    
    @FetchRequest(sortDescriptors: [])
    private var songsInGig: FetchedResults<SongInGig>
    
    @Binding var song: Song
    @Binding var pageIndex: String
    
    @Binding var updateView: Bool

    
    var body: some View {
        ZStack(alignment: .topTrailing){
            VStack{
                if song.title != nil {
                    if song.endPage != nil && song.endPage != song.startPage {
                        
                        HStack{
                            Button(action: {
                                print("back")
                                backPage()
                                print(pageIndex)
                            }) {
                                Image(systemName: "lessthan")
                            }
                            PDFKitCampireView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $pageIndex, presentationModde: true)
                            Button(action: {
                                print("nex")
                                nextPage()
                                print(pageIndex)
                            }) {
                                Image(systemName: "greaterthan")
                            }
                        }
                    } else {
                        PDFKitCampireView(book: umwantler(binding: $song.book, fallback: Book()), pageIndex: $pageIndex, presentationModde: true)
                    }
                } else {
                    Text("selekt Song")
                }
            }
            if song.isFavorit {
                Button(action: {
                    song.isFavorit = false
                    removeSongInFavoritGig()
                    saveContext()
                    updateView.toggle()
                    ec.updateGigInfoView.toggle()
                }) {
                    Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                }
            } else {
                Button(action: {
                    song.isFavorit = true
                    addSongToFavoritGig()
                    saveContext()
                    updateView.toggle()
                    ec.updateGigInfoView.toggle()
                }) {
                    Image(systemName: "star").foregroundColor(Color(UIColor.systemGray)).padding().padding()
                }
            }
        }//.frame(width: 300, height: 380.5)
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
        .onTapGesture {
            ec.song = song
            ec.presentationMode = true
        }
        .gesture(DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded({ value in
                        print(value)
                        if value.translation.width <= 0 {
                            nextPage()
                        }
                        if value.translation.width >= 0 {
                            backPage()                        }
                    }))
        .shadow( radius: 15, x: 3, y: 5)
    }
    
    func nextPage() {
        var IntPageIndex = Int(pageIndex)!
        let IntEndPage = Int(song.endPage ?? "1")!
        
        if IntPageIndex < IntEndPage {
            IntPageIndex = IntPageIndex + 1
            pageIndex = String(IntPageIndex)
        }
    }
    
    func backPage() {
        var IntPageIndex = Int(pageIndex)!
        let IntStartPage = Int(song.startPage ?? "1")!
        
        if IntPageIndex > IntStartPage {
            IntPageIndex = IntPageIndex - 1
            pageIndex = String(IntPageIndex)
        }
    }
    
    // Qelle: https://forums.swift.org/t/promoting-binding-value-to-binding-value/31055
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
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
        // updatit position hallo Kiati wie geht es dir heute ???? mir geht es gut =)
        renewPosition(songsInGig: gig.songsInGig!)
        let position = gig.songsInGig!.count// + 1
        
        newSongInGig.position = Int64(position)
        
        gig.addToSongsInGig(newSongInGig)
        saveContext()
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
    
    func renewPosition(songsInGig: NSSet) {
        
        var i = 0
        
        songsInGig.forEach{ songInGig in
            
            (songInGig as! SongInGig).position = Int64(i)
            i = i + 1
        }
    }
}

