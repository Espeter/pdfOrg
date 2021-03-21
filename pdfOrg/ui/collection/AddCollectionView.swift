//
//  AddCollectionView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 28.02.21.
//

import SwiftUI

struct AddCollectionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    
    @Binding var isActive: Bool
    @State private var addingTitel:Bool = false
    @State private var name: String = ""
    @State private var titelsToBeAdded: [Song] = []
    @State var titelsInCollection: [SongInGig] = []
    @Binding var collections: Collections
 //   var titelsToBeCopyt: [Song]?
    
    @State var foo: Bool = false
    
    @State var apdaytLokalView: Bool = true
    var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]

    @State var alert: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                List(){
                    HStack{
                        VStack{
                            Spacer()
                            TextField("LS_Name of the Collection" as LocalizedStringKey, text: $name)
                                .font(.largeTitle).padding()
                            Spacer()
                            Spacer()
                        }
                    }
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
                            TitelRowInEditMod(titelInColetion: titel, titelsInColetion: $titelsInCollection, reload: $foo)
                        }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
            }.sheet(isPresented: $addingTitel) {
                
                let tilels = Titles(songs: songs)
                
                SelectTitelForNewCollectionView(titelsToBeAdded: $titelsToBeAdded, titelsInCollection: $titelsInCollection, isActive: $addingTitel, segmentTitels: tilels.getSegmentTitles(by: alphabet), titels: tilels)
                    .environment(\.managedObjectContext, viewContext)
            }
//            .onAppear{
//                if titelsToBeCopyt != nil && titelsInCollection.count == 0 {
//                    inportCopy()
//                }
//            }
            .navigationBarTitle("LS_New Collection" as LocalizedStringKey, displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        isActive.toggle()
                                    }, label: {
                                        HStack{
                                            Text("LS_quit" as LocalizedStringKey)
                                            
                                            if apdaytLokalView {
                                                Text("")
                                            } else {
                                                Text("")
                                            }
                                        }
                                    })
                                ,trailing:
                                    Button(action: {
                                        done()
                                    }, label: {
                                        Text("LS_done" as LocalizedStringKey)
                                    })
            )
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("LS_no title in Collection" as LocalizedStringKey),
                  message: Text("LS_It is not Posibel to haf a Collection whis aut a associated Titel" as LocalizedStringKey),
                  dismissButton: .cancel(Text("LS_understood" as LocalizedStringKey))
            )
        }
    }
//    private func inportCopy(){
//
//        var i: Int64 = 1
//
//        titelsToBeCopyt?.forEach{ titel in
//
//            let newTitelInColekchen = SongInGig(context: viewContext)
//            newTitelInColekchen.position = i
//            newTitelInColekchen.song = titel
//            titelsInCollection.append(newTitelInColekchen)
//            i = i + 1
//        }
//
//
//    }
    
    private func done() {
        if titelsInCollection.count > 0 {
        collections.addCollection(title: name, titelsInCollection: titelsInCollection)
        isActive.toggle()
        } else {
            alert = true
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
        apdaytLokalView.toggle()
    }
}
