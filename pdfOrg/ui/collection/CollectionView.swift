//
//  CollectionView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 04.03.21.
//

import SwiftUI

struct CollectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    
    @State var collection :Collection
    @Binding var collections: Collections
    
    @Binding var faworitenssssisActive: Bool
    
    @State var titel: Song
    @State var titelInCollection: SongInGig
    @State var pageIndex: String = "1"
    @State private var editMode: Bool = false
    @State private var deleteCollectionAlert: Bool = false
    @State var copyCollection: Bool = false
  
    @State var copyOfTitelsInCollection: [SongInGig] = []

    @State var name: String = ""
    
    @State var reload: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            TitelCollectionVeiw(editMode: $editMode, titel: $collection.name, name: $name)
            
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                HStack {

                    CollectionPDFView(song: $titel, songInGig: $titelInCollection, pageIndex: $pageIndex, collection: $collection, Collections: collections, reload: $reload)

                    VStack{
                        Text("").padding(.top, -20).padding(.bottom, -20)
                        if editMode {
                            CollectionEditListView( titelsInCollection: $collection.titelsInCollection, tilels: Titles(songs: songs), titel: $titel, collections: $collections, collection: $collection, reload:  $reload)
                        } else {
                            CollectionListView(titel: $titel, titelInCollection: $titelInCollection, pageIndex: $pageIndex, collection: $collection, reload: $reload)
                        }
                    }
                }
            }
            else {
                VStack{
                    CollectionPDFView(song: $titel, songInGig: $titelInCollection, pageIndex: $pageIndex, collection: $collection, Collections: collections, reload: $reload)

                    if editMode {
                        CollectionEditListView( titelsInCollection: $collection.titelsInCollection, tilels: Titles(songs: songs), titel: $titel, collections: $collections, collection:  $collection, reload:  $reload)
                    } else {
                        CollectionListView(titel: $titel, titelInCollection: $titelInCollection, pageIndex: $pageIndex, collection: $collection, reload: $reload)
                    }
                    
                }
            }
        }.onAppear{
            pageIndex = collection.titels[0].startPage ?? "1"
            if name == "" {
            name = collection.name
            }
            if copyOfTitelsInCollection == [] {
                print("hallohallohallohallohallohallo")
            copyOfTitelsInCollection = collection.titelsInCollection
            }
        }
        .navigationBarTitle(/*"\(collection.name)"*/"", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if editMode {
                    Button(action: {quit()}, label: {
                        Text("LS_quit" as LocalizedStringKey)
                    })
                }
            }
            ToolbarItem(placement: .primaryAction) {
                
                if editMode {
                    Button(action: {done()}, label: {
                        Text("LS_done" as LocalizedStringKey)
                    })
                } else {
                    Menu{
                        Button(action: {editMode.toggle()}, label: {
                            Text("LS_edit" as LocalizedStringKey)
                            Spacer()
                            Image(systemName:"pencil")
                        })
                        Button(action: {copyCollection.toggle()}, label: {
                            Text("LS_copy Collection" as LocalizedStringKey)
                            Spacer()
                            Image(systemName: "doc.on.doc")
                        })
                        Button(action: {exportCollection()}, label: {
                            Text("LS_export as .txt" as LocalizedStringKey)
                            Spacer()
                            Image(systemName:"square.and.arrow.up")
                        })
                        if collection.name != "Favorites" {
                        Divider()
                        Button(action: {deleteCollectionAlert.toggle()}, label: {
                            Text("LS_delit Collection" as LocalizedStringKey)
                            Spacer()
                            Image(systemName:"trash")
                        })
                        }
                    }
                    label: {
                        Image(systemName: "ellipsis.circle").padding()
                    }
                }
            }
        }.sheet(isPresented: $copyCollection) {
            
        
            CopyCollectionUIView(isActive: $copyCollection, collections:  $collections, name: collection.name, titelsToBeCopyt: collection.titels).environment(\.managedObjectContext, viewContext)
            
          //  AddCollectionView(isActive: $copyCollection,collections: $collections, titelsToBeCopyt: collection.titels).environment(\.managedObjectContext, viewContext)
        }
        .alert(isPresented: $deleteCollectionAlert) {
            Alert(title: Text("LS_delit \(collection.name)" as LocalizedStringKey),
                  message: Text("LS_delitCollectionText \(collection.name)"),
                  primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                              action: {
                                                collections.delete(gig: collection.gig)
                                                faworitenssssisActive = true
                                              }),
                  secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
            )
        }
    }
    }

    private func exportCollection() {
        
        let text = collection.getTxet()
        let textData = text.data(using: .utf8)
        let textURL = textData?.dataToFile(fileName: "\(collection.name)_Collection.txt")
        var filesToShare = [Any]()
        filesToShare.append(textURL!)
        
        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            av.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            av.popoverPresentationController?.sourceRect = CGRect(
                x: UIScreen.main.bounds.width /*/ 2.1*/,
                y: UIScreen.main.bounds.height / 3.2,
                width: 200, height: 200
            )
        }
    }
    
    private func done() {
        collection.save(newName: name)
        editMode = false
        copyOfTitelsInCollection = collection.titelsInCollection
    }
    
    private func quit() {
        collection.quit(copyOftitelsInCollection: copyOfTitelsInCollection)
        editMode = false
    }
    
    private func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
}
