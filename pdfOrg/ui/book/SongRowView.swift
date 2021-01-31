//
//  SongRowView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 14.01.21.
//

import SwiftUI

struct SongRowView: View {
    
    @State var song: Song
    @Binding var editMode: Bool
    @Binding var page: Int
    @Binding var selectedSong: Song?
    
    @Binding var updateView: Bool
    
    @Environment(\.managedObjectContext) var viewContext
    
//    @State var titleEditable = false
//    @State var pageEditable = false
//    @State var authorEditable = false
    @State var lokalEditMode = false
    
    var body: some View {
        
        //        if editMode {
        //    //    if true {
        //            Button(action: {
        //                page = 0
        //                page = Int(song.startPage ?? "0") ?? 0
        //                selectedSong = song
        //            }) {
        //                HStack{
        //                    TextField("\(song.title ?? "nil")", text: umwantler(binding: $song.title, fallback: "error"))
        //                        .background(Color(UIColor.systemGray6))
        //                        .cornerRadius(15.0)
        //                    Spacer()
        //                    TextField("\(song.startPage ?? "nil")", text: umwantler(binding: $song.startPage, fallback: "error"))
        //                        .background(Color(UIColor.systemGray6))
        //                        .cornerRadius(15.0)
        //                    Text("-")
        //                    TextField("\(song.endPage ?? "")", text: umwantler(binding: $song.endPage, fallback: ""))
        //                        .background(Color(UIColor.systemGray6))
        //                        .cornerRadius(15.0)
        //                    Spacer()
        //                    TextField("\(song.author ?? "nil")", text: umwantler(binding: $song.author, fallback: "error"))
        //                        .background(Color(UIColor.systemGray6))
        //                        .cornerRadius(15.0)
        //                    if updateView {
        //                        Text("").frame(width: 0, height: 0)
        //                    }
        //                }
        //            }
        //        } else {
        //            Button(action: {
        //                page = 0
        //                page = Int(song.startPage ?? "0") ?? 0
        //                selectedSong = song
        //                titleEditable = false
        //                pageEditable = false
        //                authorEditable = false
        //            }) {
        HStack{
            //                    Text("\(song.title ?? "nil")").frame(maxWidth: .infinity, alignment: .leading)
            
            
            
            HStack{
                //   if titleEditable {
                if getLokalEditMode() {
                    TextField(song.title ?? "nil",
                              text: umwantler(binding: $song.title, fallback: "error"), onEditingChanged: {(changed) in
                                if changed == false {
                                    //                                            saveContext()
                                    //                                            titleEditable = false
                                }
                              }
                    ).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(15.0)
                } else {
                    Text("\(song.title ?? "nil")").frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            //                    .onTapGesture {
            ////                        titleEditable = true
            ////                        page = 0
            ////                        page = Int(song.startPage ?? "0") ?? 0
            ////                        selectedSong = song
            //                    }
            
            
            Spacer()
            
            
            //                    HStack{
            //                        Text("\(song.startPage ?? "nil")")
            //                        if song.endPage != nil && song.endPage != song.startPage{
            //                            Text("-")
            //                            Text("\(song.endPage ?? "nil")")
            //                        }
            //                    }.frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                //      if pageEditable {
                if getLokalEditMode() {
             //   if false {
                    HStack{
                        TextField(song.startPage ?? "nil",
                                  text: umwantler(binding: $song.startPage, fallback: "error"), onEditingChanged: {(changed) in
                                    if changed == false {
                                        //                                            saveContext()
                                        //                                            pageEditable = false
                                    }
                                  }).frame(width: 35, alignment: .trailing)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(15.0)
                        Text("-")
                        TextField(song.endPage ?? "",
                                  text: umwantler(binding: $song.endPage, fallback: ""), onEditingChanged: {(changed) in
                                    if changed == false {
                                        //                                            saveContext()
                                        //                                            pageEditable = false
                                    }
                                  }).frame(width: 35, alignment: .trailing)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(15.0)
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    HStack{
                        Text("\(song.startPage ?? "nil")").frame(width: 35, alignment: .trailing)
                        if song.endPage != nil && song.endPage != song.startPage{
                            Text("-")
                            Text("\(song.endPage ?? "nil")").frame(width: 35, alignment: .trailing)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            //                    .onTapGesture {
            ////                        pageEditable = true
            ////                        page = 0
            ////                        page = Int(song.startPage ?? "0") ?? 0
            ////                        selectedSong = song
            //                    }
            
            
            Spacer()
            
            
            //                    HStack{
            //                        Text("\(song.author ?? "nil")").frame(maxWidth: .infinity, alignment: .leading)
            //                        //  Spacer()
            //                        if updateView {
            //                            Text("").frame(width: 0, height: 0)
            //                        }
            //                        if song.isFavorit {
            //                            Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray))
            //                        }
            //
            //                    }.frame(maxWidth: .infinity, alignment: .leading)
            
            
            HStack{
                //  if authorEditable {
                if getLokalEditMode() {
           //        if false {
                    HStack{
                        TextField(song.author ?? "nil",
                                  text: umwantler(binding: $song.author, fallback: "error"), onEditingChanged: {(changed) in
                                    if changed == false {
                                        //                                            saveContext()
                                        //                                            authorEditable = false
                                    }
                                  }
                        ).frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(15.0)
                        if updateView {
                            Text("").frame(width: 0, height: 0)
                        }
                        if song.isFavorit {
                            Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray))
                        }
                    }
                } else {
                    HStack{
                        Text("\(song.author ?? "nil")").frame(maxWidth: .infinity, alignment: .leading)
                        if updateView {
                            Text("").frame(width: 0, height: 0)
                        }
                        if song.isFavorit {
                            Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray))
                        }
                    }
                }
                //                    }.onTapGesture {
                ////                        authorEditable = true
                ////                        page = 0
                ////                        page = Int(song.startPage ?? "0") ?? 0
                ////                        selectedSong = song
                //                    }
                
            }
        }.background(Color(UIColor.white))  // brauch ich farmit der fram größer wiert
        .onTapGesture {
            if lokalEditMode == false {
            print("onTapGesture")
            page = 0
            page = Int(song.startPage ?? "0") ?? 0
            selectedSong = song
//            titleEditable = false
//            pageEditable = false
//            authorEditable = false
          //  if lokalEditMode == false {
                editMode = false
        //    }
            // lokalEditMode = false
            saveContext()
            }
        }
        .onLongPressGesture {
            if editMode != true {
                print("onLongPressGesture")
                page = 0
                page = Int(song.startPage ?? "0") ?? 0
                selectedSong = song
//                titleEditable = true
//                pageEditable = true
//                authorEditable = true
                lokalEditMode = true
                editMode = true
            }
        }
        //                .onAppear{
        //                    print("onAppear")
        //                    lokalEditMode = false
        //                }
        .onChange(of: editMode, perform: { value in
            if value != true {
                lokalEditMode = false
            }
        })
        // }
    }
    
    func getLokalEditMode() -> Bool {
        var isEditbil: Bool
        if lokalEditMode && editMode {
            isEditbil = true
        } else {
            isEditbil = false
            
        }
        return isEditbil
    }
    
    // Qelle: https://forums.swift.org/t/promoting-binding-value-to-binding-value/31055
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
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
