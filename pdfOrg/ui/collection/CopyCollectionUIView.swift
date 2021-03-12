//
//  CopyCollectionUIView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 12.03.21.
//

import SwiftUI

struct CopyCollectionUIView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isActive: Bool
    @Binding var collections: Collections
    
    @State private var newName: String = ""
    
    
    var name: String
    var titelsToBeCopyt: [Song]
    @State var titelsInCollection: [SongInGig] = []

    
    var body: some View {
        NavigationView{
            VStack{
                List(){
                    
                    HStack{
                        VStack{
                            Spacer()
                            TextField("LS_\(name)(copy)" as LocalizedStringKey, text: $newName)
                                .font(.largeTitle).padding()
                            Spacer()
                            Spacer()
                        }
                    }
                 
                    ForEach(titelsInCollection){ songInGig in
                        
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
                    }
                }
            }
            .onAppear{
                    inportCopy()
            }
            .navigationBarTitle("LS_copy \(name)" as LocalizedStringKey, displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        isActive.toggle()
                                    }, label: {
                                        HStack{
                                            Text("LS_quit" as LocalizedStringKey)
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

        
    }
    private func inportCopy(){
        
        var i: Int64 = 1
        
        titelsToBeCopyt.forEach{ titel in
            
            let newTitelInColekchen = SongInGig(context: viewContext)
            newTitelInColekchen.position = i
            newTitelInColekchen.song = titel
            titelsInCollection.append(newTitelInColekchen)
            i = i + 1
        }
    }
    private func done() {
        
        if newName == "" {
            newName = "\(name)(copy)" // TODD: das muss noch anders
        }
        
        collections.addCollection(title: newName, titelsInCollection: titelsInCollection)

        isActive.toggle()
    }
}
