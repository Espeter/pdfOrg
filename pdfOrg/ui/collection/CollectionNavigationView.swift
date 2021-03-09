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
   // @State var titles: Titles
    
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
                    NavigationLink(destination: Text("Faworitenssss") ,isActive: $faworitenssssisActive) {
                 //   Button(action: {print("fas")}) {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(Color(UIColor.systemBlue))
                    Text("Import Collection from .txt")
                    }
                    Divider()
                   
                    
                    NavigationLink(destination: AllTitelsView(tilels: Titles(songs: songs), selectedTitel: Titles(songs: songs).array[0]) ,isActive: $allTitelsView) {
                        Image(systemName: "list.bullet")
                            .foregroundColor(Color(UIColor.systemBlue))
                    Text("LS_All Titels" as LocalizedStringKey)
                    }
                    NavigationLink(destination: Text("Faworitenssss") ,isActive: $faworitenssssisActive) {
                 //   Button(action: {print("fas")}) {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color(UIColor.systemBlue))
                    Text("Faworiten")
                    }
                    
                    Divider()
                    ForEach(collections.array) { gig in
                        
                        NavigationLink(destination: CollectionView(/*gig: gig,*/ collection: Collection(gig: gig), collections: $collections, faworitenssssisActive: $faworitenssssisActive)) {
                     //   Button(action: {print("fas")}) {
                        Text("\(gig.title ?? "error_no Title found")")
                        }
                       // }
                    }
                    
                    
                    
                }
            }.navigationBarTitle("LS_Collections" as LocalizedStringKey, displayMode: .inline)
        }.sheet(isPresented: $addingCollection) {
            AddCollectionView(isActive: $addingCollection, collections: $collections).environment(\.managedObjectContext, viewContext)
        }
    }
}
