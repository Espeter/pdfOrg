//
//  CollectionEditListView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 09.03.21.
//

import SwiftUI

struct CollectionEditListView: View {
    @EnvironmentObject var ec : EnvironmentController
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    @State var addingTitel: Bool = false
    @Binding var titelsInCollection: [SongInGig]
    @State var  tilels: Titles
    @Binding var titel: Song
    @Binding var collections: Collections
    @Binding var collection: Collection
    
    @Binding var titelInCollection: SongInGig
    @State private var titelsToBeAdded: [Song] = []
    var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    
    @Binding var reload: Bool
    @Binding var lastSongDeleted: Bool
    
    var body: some View {
        VStack{
            
            List(){
                
                Button(action: {
                    print("test")
                    addingTitel = true
                }, label: {
                    HStack{
                        Image(systemName: "plus.circle.fill").foregroundColor(Color(UIColor.systemGreen))
                        Text("LS_add Titel" as LocalizedStringKey).foregroundColor(Color(UIColor.systemBlue)).padding()
                    }.font(.title2)
                })
                ForEach(titelsInCollection){ titel in
                    if titel.song != nil {
                        
                        Button(action: {selecttitel(song: titel.song!)}, label: {
                            
                            TitelRowInEditMod(titelInColetion: titel, titelsInColetion: $titelsInCollection, reload: $reload)
                            
                        })
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
                
            }
                .sheet(isPresented: $addingTitel) {

                    //    let tilels = Titles(songs: titelsInCollection)

                    SelectTitelForNewCollectionView(collection: collection.gig, titelsToBeAdded: $titelsToBeAdded, titelsInCollection: $titelsInCollection, isActive: $addingTitel, segmentTitels: tilels.getSegmentTitles(by: alphabet, songs: songs), titels: tilels)
                            .environment(\.managedObjectContext, viewContext)
                    }
            
        }
    }
    
    private func selecttitel(song: Song) {
        titel = song
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            if titelsInCollection.count > 1 {
                var newPosichen = titelsInCollection[offsets.first!].position - 2
                
                if newPosichen < 0 {
                    newPosichen = 0
                }
                
                if collection.name == "Favorites" {
                    collections.removeFavorites(song: titelsInCollection[offsets.first!].song!)
                }
                offsets.map {titelsInCollection[$0]}.forEach(viewContext.delete)
                titelsInCollection.remove(at: offsets.first!)
                renewPosition(songsInGig: titelsInCollection)
                
                if titelsInCollection.count <= newPosichen {
                    newPosichen = newPosichen - 1
                }
                
                print("newPosichen: \(newPosichen)")
                print("titelsInCollection[Int(newPosichen)]: \(titelsInCollection.count)")
                 
                titelInCollection = titelsInCollection[Int(newPosichen)]
                titel = titelsInCollection[Int(newPosichen)].song!
            } else {
                lastSongDeleted.toggle()
            }
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        
        var destinationNew = destination
        
        let element = titelsInCollection.remove(at: source.first!)
        if destinationNew >= titelsInCollection.count {
            destinationNew = destination - 1
        }
        titelsInCollection.insert(element, at: destinationNew )
        
        renewPosition(songsInGig: titelsInCollection)
        
        reload.toggle()
       
        
    }
    
    private func renewPosition(songsInGig: [SongInGig]) {
        
        var i = 1
        
        songsInGig.forEach{ songInGig in
            
            songInGig.position = Int64(i)
            i = i + 1
        }
        //   apdaytLokalView.toggle()
    }
}
