//
//  SelectTitelForNewCollectionView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 01.03.21.
//

import SwiftUI

struct SelectTitelForNewCollectionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    @State var collection: Gig?
    @State private var searchText: String = ""
    @Binding var titelsToBeAdded: [Song]
    @Binding var titelsInCollection: [SongInGig]
    
    @Binding var isActive: Bool
    
    var segmentTitels : [String: [Song]]
    var titels: Titles
    var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    
    var body: some View {
        VStack{
            Text("LS_add Titel to new Collection" as LocalizedStringKey)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color("BarColor"))
                .padding(.bottom, -10)
            NavigationView{
                VStack {
                    SearchBar(text: $searchText)
                        .padding()
                        .padding(.top, -15)
                        .padding(.bottom, -15)
                        .background(Color("BarColor"))
                    Divider().padding(.top, -10)
                    
                    if searchText == "" {
                        
                        ScrollViewReader { scroll in
                            HStack{
                                List(){
                                    
                                    ForEach(alphabet, id: \.self){ char in
                                        
                                        if segmentTitels[char]!.count > 0 {
                                            Section(header: Text(char).id(char)) {
                                                ForEach(segmentTitels[char]!, id: \.self) { (song: Song) in
                                                    
                                                    NavigationLink(destination: AddTitelPresentationView(titel: song, isInAddMod: true, titelsToBeAdded: $titelsToBeAdded, book: song.book ?? Book(), pageIndex: song.startPage ?? "1", isLandscape: false)) {
                                                        AddTitelRowView(titel: song, titelsToBeAdded: $titelsToBeAdded)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                VStack{
                                    ScrollView{
                                        ForEach(alphabet, id: \.self){ char in
                                            Button(char){
                                                scroll.scrollTo(char, anchor: .top)
                                            }
                                        }
                                    }.padding(.trailing, 10)
                                }
                            }
                        }.padding(.top, -17)
                    } else {
                        List {
                            ForEach(titels.getSearchResult(searchTerms: searchText, songs: songs), id: \.self) { (song: Song) in
                                
                                NavigationLink(destination: AddTitelPresentationView(titel: song, isInAddMod: true, titelsToBeAdded: $titelsToBeAdded, book: song.book ?? Book(), pageIndex: song.startPage ?? "1", isLandscape: false)) {
                                    AddTitelRowView(titel: song, titelsToBeAdded: $titelsToBeAdded)
                                }
                                
                            }
                        }
                    }
                }
                .navigationBarTitle("LS_Titels" as LocalizedStringKey, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {quit()}, label: {
                            Text("LS_quit" as LocalizedStringKey)
                        })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {done()}, label: {
                            Text("LS_done" as LocalizedStringKey)
                        })
                    }
                }
            }
        }
    }
    
    private func quit() {
        titelsToBeAdded = []
        isActive = false
    }
    
    private func done() {
        
        titelsToBeAdded.forEach{ titel in
            
            let newTitelInCollection = SongInGig(context: viewContext)
            newTitelInCollection.song = titel
            newTitelInCollection.position = Int64(titelsInCollection.count + 1)
            newTitelInCollection.gig = collection
            titelsInCollection.append(newTitelInCollection)
        }
        titelsToBeAdded = []
        isActive = false
    }
}
