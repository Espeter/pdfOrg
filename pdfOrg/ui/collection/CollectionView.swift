//
//  CollectionView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 04.03.21.
//

import SwiftUI

struct CollectionView: View {
    
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    
    // @State var gig: Gig
    @State var collection :Collection
    @Binding var collections: Collections
    
    @Binding var faworitenssssisActive: Bool
    
    @State var titel: Song
    @State var titelInCollection: SongInGig
    @State var pageIndex: String = "1"
    @State private var editMode: Bool = false
    @State private var deleteCollectionAlert: Bool = false
  
    
    @State var name: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            TitelCollectionVeiw(editMode: $editMode, titel: collection.name, name: $name)
            
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                HStack {
           //         if titel != nil {
          //              AllTitelsPDFView(song: $titel, pageIndex: $pageIndex)
                        CollectionPDFView(song: $titel, songInGig: $titelInCollection, pageIndex: $pageIndex, collection: collection)
  //                  CollectionPDFView(song: $titel, songInGig: umwantler(binding: $titelInCollection, fallback: SongInGig()), pageIndex: $pageIndex, collection: collection)
//                    } else {
//                        Text("pdf")
             //       }
                    VStack{
                        Text("").padding(.top, -20).padding(.bottom, -20)
                        if editMode {
                            CollectionEditListView( titelsInCollection: collection.titelsInCollection, tilels: Titles(songs: songs))
                        } else {
                            CollectionListView(titel: $titel, titelInCollection: $titelInCollection, pageIndex: $pageIndex, collection: collection)
                        }
                    }
                }
            }
            else {
                VStack{
              //      if titel != nil {
                        CollectionPDFView(song: $titel, songInGig: $titelInCollection, pageIndex: $pageIndex, collection: collection)
         //               AllTitelsPDFView(song: umwantler(binding: $titel, fallback: Song()), pageIndex: $pageIndex)
      //                  CollectionPDFView(song: $titel, songInGig: umwantler(binding: $titelInCollection, fallback: SongInGig()), pageIndex: $pageIndex, collection: collection)
         //               CollectionPDFView(song: umwantler(binding: $titel, fallback: Song()), songInGig: umwantler(binding: $titelInCollection, fallback: SongInGig()), pageIndex: $pageIndex, collection: collection)
//                    } else {
//                        Text("pdf")
//                    }
                    if editMode {
                        CollectionEditListView( titelsInCollection: collection.titelsInCollection, tilels: Titles(songs: songs))
                    } else {
                        CollectionListView(titel: $titel, titelInCollection: $titelInCollection, pageIndex: $pageIndex, collection: collection)
                    }
                    
                }
            }
        }.onAppear{
//            if titel == nil && collection.titels.count > 0 {
//                titel = collection.titels[0]
//                titelInCollection = collection.titelsInCollection[0]
                pageIndex = collection.titels[0].startPage ?? "1"
              
       //     }
            if name == "" {
            name = collection.name
            }
        }
        .navigationBarTitle(/*"\(collection.name)"*/"", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
//            ToolbarItem(placement: .status) {
//                Text("fff")
//            }
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
                        Button(action: {exportCollection()}, label: {
                            Text("LS_export as .txt" as LocalizedStringKey)
                            Spacer()
                            Image(systemName:"square.and.arrow.up")
                        })
                        Divider()
                        Button(action: {deleteCollectionAlert.toggle()}, label: {
                            Text("LS_delit Collection" as LocalizedStringKey)
                            Spacer()
                            Image(systemName:"trash")
                        })
                    }
                    label: {
                        Image(systemName: "ellipsis.circle").padding()
                    }
                }
            }
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
    //    private func deleteCollection() {
    //        collections.delete(gig: collection.gig)
    //    }
    
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
    
    //    private func titelSelected(song: Song, songInGigi: SongInGig) {
    //        titel = song
    //        titelInCollection = songInGigi
    //        pageIndex = song.startPage ?? "1"
    //    }
    
    private func done() {
        print("done")
    }
    
    private func quit() {
        print("quit")
    }
    
    private func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
}
