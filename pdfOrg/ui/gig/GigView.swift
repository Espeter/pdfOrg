//
//  GigView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 15.01.21.
//

import SwiftUI

struct GigView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var songsFR: FetchedResults<Song>
    
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    
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
    
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    
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
                                            print("export")
                                        }) {
                                            Image(systemName: "square.and.arrow.up")
                                        }
                                        
                                        Button(action: {
                                            showingPopup.toggle()
                                        }) {
                                            Image(systemName: "doc.on.doc").padding().popover(isPresented: self.$showingPopup) {
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
                                                Image(systemName: "plus")
                                            }
                                        }
                                    }
            )
            .background(Color(UIColor.systemBlue).opacity(0.05))
        }.navigationViewStyle(StackNavigationViewStyle())
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
        
        txt = "\(String(describing: gig.title))\n"
        
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
    
    func getArraySong(_ snSet : NSSet) -> [SongInGig] {
        
        let songsInGig = snSet.allObjects as! [SongInGig]
        
        let sortedSongsInGig = songsInGig.sorted {
            $0.position < $1.position
        }
        return sortedSongsInGig
    }
    
}
