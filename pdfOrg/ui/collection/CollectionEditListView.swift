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
    

    @State private var titelsToBeAdded: [Song] = []
    var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]


    
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
                                TitelRowInEditMod(titelInColetion: titel, titelsInColetion: $titelsInCollection)
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
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map {titelsInCollection[$0]}.forEach(viewContext.delete)
            titelsInCollection.remove(at: offsets.first!)
            renewPosition(songsInGig: titelsInCollection)
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
