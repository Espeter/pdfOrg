//
//  EditSongView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 30.03.21.
//

import SwiftUI

struct EditSongView: View {
    
    @EnvironmentObject var ec : EnvironmentController
    @EnvironmentObject var ecb : EnvironmentControllerBook

    
    @Environment(\.managedObjectContext) var viewContext
    @State var book: Book
    @Binding var song: Song?
    @Binding var page: Int
    
    @Binding var updayitView: Bool
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            HStack{
                if song == nil {
                    
                    Spacer()
                    Button(action: {add()}, label: {
                        Text("LS_add" as LocalizedStringKey)
                            .foregroundColor(Color(UIColor.systemBlue))
                            .padding(.trailing, 15)
                            .padding(.top, 15)
                    })
                } else {
                    Spacer().frame(width: 0)
                    
                    Spacer()
                    Button(action: {
                        additSong()
                    }) {
                        Text("LS_save" as LocalizedStringKey)
                            .foregroundColor(Color(UIColor.systemBlue))
                            .padding(.trailing, 15)
                            .padding(.top, 15)
                    }
                }
            }.padding(.bottom,-5)
            HStack{
                HStack{
                    Text("LS_Titel Name: " as LocalizedStringKey).padding(.leading, 15)
                    myTextField( text: $ecb.titelName)
                    
                }
                HStack{
                    Text("LS_Titel Label: " as LocalizedStringKey)
                    myTextField( text: $ecb.label)
                    
                }
            }
            HStack{
                HStack{
                    Text("LS_first Page: " as LocalizedStringKey).padding(.leading, 15)
                    myTextField( text: $ecb.startPage)
                }
                HStack{
                    Text("LS_last Page" as LocalizedStringKey)
                    myTextField(text: $ecb.endPage)
                }
            }
            //   }.frame( height: 25)
            //            Divider()
            //        }.background(Color(UIColor.systemGray6))
        }.padding().background(Color(UIColor.systemGray6)).cornerRadius(15.0).padding().padding(.top, -15)
    }
    
    private   func add(){
        let newSong = Song(context: viewContext)
        newSong.title = ecb.titelName
        newSong.startPage = ecb.startPage
        newSong.endPage = ecb.endPage
        newSong.author =  ecb.label
        newSong.book = book
        newSong.id = UUID()
        newSong.isFavorit = false
        updayitView.toggle()
        song = newSong
    }
    private func additSong() {
    
        song!.title = ecb.titelName
        song!.startPage = ecb.startPage
        song!.endPage = ecb.endPage
        song!.author =  ecb.label
    
        updayitView.toggle()
    }
    
    private func saveContext(){
        do{
            try viewContext.save()
        }
        catch {
            let error = error as NSError
            fatalError("error addBook: \(error)")
        }
    }
}
