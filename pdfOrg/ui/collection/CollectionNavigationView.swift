//
//  CollectionNavigationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 26.02.21.
//

import SwiftUI

struct CollectionNavigationView: View {
    
    @State var collections: Collections
    @Environment(\.managedObjectContext) private var viewContext
    @State var apdaytLokalView: Bool = true
   // @State var titles: Titles
    
    @State var addingCollection: Bool = false
    
   // @State private var fooo: Bool = false
    
    var body: some View {
        
        NavigationView{
            VStack{
                List(){
                    
                    ForEach(collections.array) { collection in
                        
                        NavigationLink(destination: /*GigView(gig: collections.getFavoritCollection(titles: titles.array))*/Text("test")) {
                            Text("\(collection.title ?? "error_no Title found")")
                        }
                    }.onDelete(perform: deleteCollection)
                    Button(action: {addingCollection.toggle()}) {
                        HStack{
                            Image(systemName: "plus")
                                .foregroundColor(Color(UIColor.systemBlue))
                            Text("LS_new Collection" as LocalizedStringKey)
                        }
                    }
                }
            }.navigationBarTitle("LS_Collections" as LocalizedStringKey, displayMode: .inline)
        }.sheet(isPresented: $addingCollection) {
            AddCollectionView(isActive: $addingCollection, collections: $collections).environment(\.managedObjectContext, viewContext)
        }
    }
    
    private func deleteCollection(offsets: IndexSet) {
        withAnimation {
            collections.delete(offsets: offsets)
        }
    }
}
