//
//  CollectionNavigationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 26.02.21.
//

import SwiftUI

struct CollectionNavigationView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    
    @State var collections: Collections
    @Environment(\.managedObjectContext) private var viewContext
    @State var apdaytLokalView: Bool = true
    
    @State var addingCollection: Bool = false
    
    @State var faworitenssssisActive: Bool = true
    @State var allTitelsView: Bool = true
    
    var body: some View {
        
        NavigationView{
            VStack{
                List(){
                    
                    Button(action: {addingCollection.toggle()}) {
                        HStack{
                            Image(systemName: "plus")
                                .foregroundColor(Color(UIColor.systemBlue))
                            Text("LS_New Collection" as LocalizedStringKey)
                        }
                    }
                    
                    Button(action: {addingCollection.toggle()}) {
                        HStack{
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(Color(UIColor.systemBlue))
                            Text("Import Collection from .txt")
                        }
                    }
         
                    Divider()
                           
                    NavigationLink(destination: AllTitelsView(tilels: Titles(songs: songs), selectedTitel: Titles(songs: songs).array[0], collections: $collections) ,isActive: $allTitelsView) {
                        
                        Image(systemName: "list.bullet")
                            .foregroundColor(allTitelsView ? Color(UIColor.white) : Color(UIColor.systemBlue))
                        
                        Text("LS_All Titels" as LocalizedStringKey)
                    }
                    
                    let faworitenGig = collections.get(collection: "Favorites")
                    
                    if faworitenGig.songsInGig!.count > 0 {
                    
                    NavigationLink( destination: CollectionView(collection: Collection(gig: faworitenGig), collections: $collections, faworitenssssisActive: $faworitenssssisActive, titel: Collection(gig: faworitenGig).titels[0], titelInCollection: Collection(gig: faworitenGig).titelsInCollection[0]) , isActive: $faworitenssssisActive) {
                        
                        Image(systemName: "star.fill")
                            .foregroundColor( Color(UIColor.systemBlue))//faworitenssssisActive ? Color(UIColor.yellow) : Color(UIColor.systemBlue))
                        Text("Faworiten")
                    }
                    }
                    Divider()
                    
                    ForEach(collections.array) { gig in
                        
                        if Collection(gig: gig).titels.count > 0 && gig.title != "Favorites" {
                            NavigationLink(destination: CollectionView(collection: Collection(gig: gig), collections: $collections, faworitenssssisActive: $faworitenssssisActive, titel: Collection(gig: gig).titels[0], titelInCollection: Collection(gig: gig).titelsInCollection[0])) {
                                
                                Text("\(gig.title ?? "error_no Title found")")
                            }
                        }
                    }
                }
            }.navigationBarTitle("LS_Collections" as LocalizedStringKey, displayMode: .inline)
        }.sheet(isPresented: $addingCollection) {
            AddCollectionView(isActive: $addingCollection, collections: $collections).environment(\.managedObjectContext, viewContext)
        }
    }
    
}
