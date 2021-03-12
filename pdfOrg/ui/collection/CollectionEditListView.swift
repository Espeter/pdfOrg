//
//  CollectionEditListView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 09.03.21.
//

import SwiftUI

struct CollectionEditListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var addingTitel: Bool = false
    @Binding var titelsInCollection: [SongInGig]
    @State var  tilels: Titles
    @Binding var titel: Song
    @Binding var collections: Collections
    @Binding var collection: Collection
    
    
    @State private var titelsToBeAdded: [Song] = []
    var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    
    @Binding var reload: Bool
    
    var body: some View {
        VStack{
            
            List(){
                
                Button(action: {
                    addingTitel.toggle()
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
        }.sheet(isPresented: $addingTitel) {
            
            //        let tilels = Titles(songs: songs)
            
            SelectTitelForNewCollectionView(titelsToBeAdded: $titelsToBeAdded, titelsInCollection: $titelsInCollection, isActive: $addingTitel, segmentTitels: tilels.getSegmentTitles(by: alphabet), titels: tilels)
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    private func selecttitel(song: Song) {
        titel = song
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            
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
            
            titel = titelsInCollection[Int(newPosichen)].song!
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
