//
//  CollectionView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 04.03.21.
//

import SwiftUI

struct CollectionView: View {
    
    // @State var gig: Gig
    @State var collection :Collection
    @Binding var collections: Collections
    
    @Binding var faworitenssssisActive: Bool
    
    @State var titel: Song?
    @State var titelInCollection: SongInGig?
    @State var pageIndex: String = "1"
    @State private var editMode: Bool = false
    @State private var deleteCollectionAlert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                HStack {
                    if titel != nil {
                        CollectionPDFView(song: umwantler(binding: $titel, fallback: Song()), songInGig: umwantler(binding: $titelInCollection, fallback: SongInGig()), pageIndex: $pageIndex, collection: collection)
                    } else {
                        Text("pdf")
                    }
                    List() {
                        
                        ForEach(collection.titelsInCollection) { songInGig in
                            
                            if songInGig.song != nil {
                                
                                Button(action: {titelSelected(song: songInGig.song!,songInGigi: songInGig)}, label: {
                                    HStack{
                                        Text("\(songInGig.position).").font(.title3).padding(.trailing, 10)
                                        
                                        VStack(alignment: .leading){
                                            HStack{
                                                Text(songInGig.song!.title ?? "error_no Titel")
                                                if songInGig.song!.isFavorit {
                                                    Image(systemName: "star.fill").padding(.leading, 10)
                                                }
                                            }
                                            HStack{
                                                Text(songInGig.song!.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
                                                Spacer()
                                                Text(songInGig.song!.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                                            }.font(.footnote)
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            else {
                VStack{
                    
                    if titel != nil {
                        CollectionPDFView(song: umwantler(binding: $titel, fallback: Song()), songInGig: umwantler(binding: $titelInCollection, fallback: SongInGig()), pageIndex: $pageIndex, collection: collection)
                    } else {
                        Text("pdf")
                    }
                    List() {
                        
                        ForEach(collection.titelsInCollection) { songInGig in
                            
                            if songInGig.song != nil {
                                
                                Button(action: {titelSelected(song: songInGig.song!,songInGigi: songInGig)}, label: {
                                    HStack{
                                        Text("\(songInGig.position).").font(.title3).padding(.trailing, 10)
                                        
                                        VStack(alignment: .leading){
                                            HStack{
                                                Text(songInGig.song!.title ?? "error_no Titel")
                                                if songInGig.song!.isFavorit {
                                                    Image(systemName: "star.fill").padding(.leading, 10)
                                                }
                                            }
                                            HStack{
                                                Text(songInGig.song!.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
                                                Spacer()
                                                Text(songInGig.song!.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                                            }.font(.footnote)
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }.onAppear{
            if titel == nil && collection.titels.count > 0 {
                titel = collection.titels[0]
                titelInCollection = collection.titelsInCollection[0]
                pageIndex = collection.titels[0].startPage ?? "1"
            }
        }
        .navigationBarTitle("\(collection.name)")//), displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                
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
    
    private func titelSelected(song: Song, songInGigi: SongInGig) {
        titel = song
        titelInCollection = songInGigi
        pageIndex = song.startPage ?? "1"
    }
    
    private func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
}
