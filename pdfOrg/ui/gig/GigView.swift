//
//  GigView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 15.01.21.
//

import SwiftUI

struct GigView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var ec : EnvironmentController
    
    @FetchRequest(sortDescriptors: [])
    private var songsFR: FetchedResults<Song>
    
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    
    @FetchRequest(sortDescriptors: [])
    var books: FetchedResults<Book>
    
    @State var showingSelectGigView: Bool = false
    @State var showingAddGigSongView: Bool = false
    
    @State var gig: Gig
    @State var song: Song?
    @State var songInGig: SongInGig?
    
    @State var updateView: Bool = true
    
    @State var songIsSelectet: Bool = false
    @State var gigSongIsSelectet: Bool = false
    
    @State var pageIndex: String = "1"
    @State var showingPopup: Bool = false
    @State var copyGigTitel: String = ""
    @State var openFile: Bool = false
    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    
    @State var notExistingBooks: [String] = []
    @State var bookAlert: Bool = false
    
    var body: some View {
        
        NavigationView{
            
            HStack{
                
                if showingAddGigSongView {
                    VStack{
                        //      GigInfoView(gig: umwantler(binding: $gig, fallback: Gig()), updateView: $updateView)
                        GigInfoView(gig: $gig, updateView: $updateView, songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, songInGig: $songInGig, pageIndex: $pageIndex, song: $song)
                            .padding()
                        GigPDFView(songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, song: $song, pageIndex: $pageIndex, songInGig: $songInGig, gig: $gig, showingSelectGigView: $showingSelectGigView)
                            .padding()
                            .padding(.top, -20)
                    }
                    SelectGigSongView(songs: getArraySong(), gig:  $gig, alphabet: alphabet, segmentSongs: getSegmentSongs(), updateView: $updateView, songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, songSelectet: $song, pageIndex: $pageIndex)
                        .padding()
                        .padding(.leading, -20)
                    
                } else {
                    GigPDFView(songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, song: $song, pageIndex: $pageIndex, songInGig: $songInGig, gig:  $gig, showingSelectGigView: $showingSelectGigView).padding()
                    //     GigInfoView(gig: umwantler(binding: $gig, fallback: Gig()), updateView: $updateView)
                    GigInfoView(gig: $gig, updateView: $updateView, songIsSelectet: $songIsSelectet, gigSongIsSelectet: $gigSongIsSelectet, songInGig: $songInGig, pageIndex: $pageIndex, song: $song)
                        .padding()
                        .padding(.leading, -20)
                }
                
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                                    HStack{
                                        Text("Collection: ")
                                        Button(action: {
                                            showingSelectGigView.toggle()
                                        }) {
                                            Text("\(gig.title ?? "selector Gig")")
                                                .popover(isPresented: self.$showingSelectGigView) {
                                                    SelectGigView(gig: $gig, showingPopup: $showingSelectGigView)
                                                }
                                        }
                                    }
                                ,trailing:
                                    HStack{
                                        Button(action: {
                                            openFile.toggle()
                                            
                                            gigs.forEach{ gig in
                                                print("print(gig.title)")
                                                print(gig.title)
                                            }
                                            
                                            
                                            
                                        }) {
                                            Image(systemName: "square.and.arrow.down")
                                        }
                                        Button(action: {
                                            exportCollection()
                                        }) {
                                            Image(systemName: "square.and.arrow.up").padding()
                                        }
                                        Button(action: {
                                            showingPopup.toggle()
                                        }) {
                                            Image(systemName: "doc.on.doc").popover(isPresented: self.$showingPopup) {
                                                VStack{
                                                    
                                                    
                                                    HStack{
                                                        Text("Copy Collection").foregroundColor(Color(UIColor.black))//.padding()
                                                        Spacer()
                                                    }.frame( alignment: .leading)
                                                    Text("")
                                                    HStack{
                                                        Text("from: \(gig.title!)").foregroundColor(Color(UIColor.black))
                                                        Spacer()
                                                    }.frame( alignment: .leading)
                                                    Text("")
                                                    HStack{
                                                        
                                                        Text("to: ").foregroundColor(Color(UIColor.black))
                                                        TextField("Copy Collection", text: $copyGigTitel)
                                                    }.frame( alignment: .leading)
                                                    
                                                    
                                                    Text("")
                                                    Button(action: {
                                                        showingPopup.toggle()
                                                        copyGig(titel: copyGigTitel)
                                                    }) {
                                                        Text("Copy ").foregroundColor(Color(UIColor.white)).padding().background(Color(UIColor.systemBlue)).cornerRadius(15.0).padding()
                                                    }
                                                }.padding().frame(width: 200, height: 300)
                                            }
                                        }
                                        if gig.title != "Favorites" {
                                            Button(action: {
                                                showingAddGigSongView.toggle()
                                            }) {
                                                Image(systemName: "plus").padding()
                                            }
                                        }
                                    }
            )
            .background(Color(UIColor.systemBlue).opacity(0.05))
        }.navigationViewStyle(StackNavigationViewStyle())
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.text])
        { (res) in
            do {
                let fileUrl = try res.get()
                importCollection(url: fileUrl)
                
            }
            catch {
                print("error")
            }
        }
        .alert(isPresented: $bookAlert) {
            Alert(title: Text("Book id esestiert nicht"),
                  message: Text("die folgenden Book IDs exestieren nicht: \(getnotExistingBooks())"),
                  dismissButton: .cancel(Text("Oky"))
            )
        }
        
    }
    
    func getnotExistingBooks() -> String {
        
        var existingBooksString: String = "\n"
        
        notExistingBooks.forEach{ bookID in
            existingBooksString = existingBooksString + bookID + "\n"
        }
        return existingBooksString
    }
    
    
    
    func importCollection(url: URL) {
        
        
        var txt = String()
        
        do{
            guard url.startAccessingSecurityScopedResource() else {
                return
            }
            //  txt = try NSString(contentsOf: url, encoding: String.Encoding.ascii.rawValue) as String
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
                
                //   newGig.addToSongsInGig(importSongsInGig(position: position, songTeitel: lineSplit[0], bookId:  lineSplit[1]))
                //addSong(name: lineSplit[0], startSide: lineSplit[1],endPage: lineSplit[2], author: lineSplit[3])
                //   position = position + 1
            }
        })
        
        let allNonExistentBooks  = allBooksExist(importetSongs)
        
        if allNonExistentBooks == nil {
            let newGig = Gig(context: viewContext)
            newGig.title = titel
            importetSongs.forEach { importetSong in
                newGig.addToSongsInGig(importSongsInGig(position: position, songTeitel: importetSong.teitel, bookId:  importetSong.bookId))
                position = position + 1
            }
            newGig.id = UUID()
            saveContext()
            gig = newGig
        } else {
            notExistingBooks = allNonExistentBooks!
            bookAlert.toggle()
            print("error")
        }
        print("titeltiteltiteltiteltiteltiteltiteltiteltiteltiteltiteltitel:")
        print(titel)
        url.stopAccessingSecurityScopedResource()
        
    }
    
    func allBooksExist(_ importetSongs: [(teitel: String, bookId: String)]) -> [String]? {
        
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
    
    func importSongsInGig(position: Int64, songTeitel: String, bookId: String) -> SongInGig {
        
        let newSongInGig = SongInGig(context: viewContext)
        
        newSongInGig.position = Int64(position)
        
        books.forEach{ book in
            
            if book.id == bookId {
                
                getArraySONG(book.songs!).forEach{ song in
                    
                    if song.title == songTeitel {
                        newSongInGig.song = song
                    }
                }
            }
        }
        
        if newSongInGig.song == nil {
            newSongInGig.bookId = bookId
            newSongInGig.teitel = songTeitel
            
            newSongInGig.song = get404Song(teitel: songTeitel)
            // import 404 Book
            
        }
        
        
        return newSongInGig
    }
    
    func get404Song(teitel: String) -> Song {
        
        
        let gBookID = ec.gBookID
        
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
    
    
    
    func exportCollection() {
        
        let text = getCollectionTxt()
        let textData = text.data(using: .utf8)
        let textURL = textData?.dataToFile(fileName: "\(gig.title!)_Collection.txt")
        var filesToShare = [Any]()
        filesToShare.append(textURL!)
        
        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            av.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            av.popoverPresentationController?.sourceRect = CGRect(
                x: UIScreen.main.bounds.width / 2.1,
                y: UIScreen.main.bounds.height / 1.5,
                width: 200, height: 200
            )
        }
    }
    
    func getCollectionTxt() -> String {
        
        var txt: String
        
        txt = "\(String(describing: gig.title!))\n"
        
        getArraySong(gig.songsInGig!).forEach { songInGig in
            
            let title = String((songInGig.song?.title)!)
            let id = String((songInGig.song?.book?.id)!)
            
            txt = txt + "\(title);\(id)\n"
        }
        return txt
    }
    
    func copyGig(titel: String) {
        
        let copyGig: Gig = Gig(context: viewContext)
        
        if titel == "" {
            copyGig.title = "\(gig.title!) copy"
        } else {
            copyGig.title = titel
        }
        
        
        copyGig.id = UUID()
        
        gig.songsInGig?.forEach { songInGig in
            
            let newSongInGig  = SongInGig(context: viewContext)
            newSongInGig.position = (songInGig as! SongInGig).position
            newSongInGig.song = (songInGig as! SongInGig).song
            
            copyGig.addToSongsInGig(newSongInGig)
        }
        
        saveContext()
        gig = copyGig
        
    }
    
    
    
    
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
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
    
    func getSegmentSongs() -> [String: [Song]] {
        print("getSegmentSongs()")
        var dictionary: [String: [Song]] = [:]
        
        alphabet.forEach{ char in
            dictionary[char] = []
        }
        // dictionary["#"] = []
        
        getArraySong().forEach{ song in
            let firstLetter = song.title?.first?.lowercased()
            
            if (dictionary[firstLetter!] != nil) {
                dictionary[firstLetter!]?.append(song)
            } else {
                dictionary["#"]?.append(song)
            }
        }
        return dictionary
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
    
    func getArraySONG(_ snSet : NSSet) -> [Song] {
        
        let songsInGig = snSet.allObjects as! [Song]
        
        let sortedSongsInGig = songsInGig.sorted {
            $0.title! < $1.title!
        }
        return sortedSongsInGig
    }
    
    
    func getArraySong(_ snSet : NSSet) -> [SongInGig] {
        
        let songsInGig = snSet.allObjects as! [SongInGig]
        
        let sortedSongsInGig = songsInGig.sorted {
            $0.position < $1.position
        }
        return sortedSongsInGig
    }
    
}
