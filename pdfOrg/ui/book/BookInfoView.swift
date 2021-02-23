//
//  BookInfoView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookInfoView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])
     var books: FetchedResults<Book>
    @EnvironmentObject var ec : EnvironmentController

    @ObservedObject var book: Book
    @Binding var editMode: Bool
    @State var showingPopup = false
    @Binding var updateView: Bool
    
    @State var orientation: Int
    let orientations = ["rectangle.portrait", "rectangle"]
    
    @State private var oldId: String?
    @State var idAlert: Bool = false
    
    var body: some View {
        
        VStack {
            HStack{
                Text("Title: ").foregroundColor(Color(UIColor.black))
                TextField(book.title!, text: umwantler(binding: $book.title, fallback: "nil"), onEditingChanged: {(changed) in
                    if changed == false {
                        saveContext()
                        updateView.toggle()
                        ec.updatLibrary.toggle()
                    }
                })
            }
            HStack{
                Text("Orientation : ").foregroundColor(Color(UIColor.black))
        
                Picker("", selection: $orientation){
                 
                    ForEach(0 ..< orientations.count, id: \.self) {
                        Image(systemName: orientations[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .onChange(of: orientation) {
                    book.isLandscape = Int64($0)
                    saveContext()
                }
            }
            HStack{
                Text("id: ").foregroundColor(Color(UIColor.black))
                TextField(book.id!, text: umwantler(binding: $book.id, fallback: "nil"), onEditingChanged: {(changed) in
                    
                    if oldId == nil {
                        oldId = book.id
                    }
                    
                    if changed == false {

                        if oldId != book.id {
                            if idDoesNotExist(/*id: book.id!*/) {
                                saveContext()
                                updateView.toggle()
                                oldId = nil
                            } else {
                                idAlert.toggle()
                                book.id = oldId
                                oldId = nil
                            }
                        } else {
                            oldId = nil
                        }
                    }
                })
            }

            
            
            HStack{
                
                HStack{
                    Text("Label: ").foregroundColor(Color(UIColor.black))
                    TextField(book.label ?? "", text: umwantler(binding: $book.label, fallback: ""), onEditingChanged: {(changed) in
                        if changed == false {
                            saveContext()
                            updateView.toggle()
                            ec.updatLibrary.toggle()
                        }
                    })
                }
                
//                Text("Label: ")
//                if editMode {
//                    TextField("\(book.label ?? "nil")", text: umwantler(binding: $book.label, fallback: "error")).padding(0).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
//                } else {
//                    Text("\(book.label ?? "nil")")
//                }
                Spacer()
            }.padding(.bottom, 4)
            
            HStack{
                Text("Version: ")
                if editMode {
                    TextField("\(book.version ?? "nil")", text: umwantler(binding: $book.version, fallback: "error")).padding(0).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
                } else {
                    Text("\(book.version ?? "nil")")
                }
                Spacer()
            }.padding(.bottom, 4)
            
            HStack{
                Text("\(String(book.songs!.count)) Songs")
                Spacer()
            }.padding(.bottom, 4)
            
            HStack{
                Text("Page Offset: ")
                if editMode {
                    TextField("\(book.pageOfset ?? "nil")", text: umwantler(binding: $book.pageOfset, fallback: "error")).padding(0).background(Color(UIColor.systemGray6)).cornerRadius(15.0)
                } else {
                    Text("\(book.pageOfset ?? "nil")")
                    Spacer()
                }
                
                Button(action: {
                    showingPopup.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .popover(isPresented: self.$showingPopup) {
                            Text("Das sind die Infos zum dem Page Offset").padding()
                        }
                }
            }.padding(.bottom, 4).padding(.top, 4)
        }.frame(minWidth: 100, maxHeight: .infinity)
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(15.0)
        .alert(isPresented: $idAlert) {
            Alert(title: Text("id already exists"),
                  message: Text("this ID already exists"),
                  dismissButton: .cancel(Text("Oky"))
            )
        }
        
    }
    
    private func idDoesNotExist(/*id: String*/) -> Bool {
        
        var idDoesNotExistInt: Int = 0
      var idDoesNotExist = true
        
        books.forEach{ book in
           
            if book.id == self.book.id {
                idDoesNotExistInt = idDoesNotExistInt + 1
            }
        }
        if idDoesNotExistInt >= 2 {
            idDoesNotExist = false
        }
        
        return idDoesNotExist
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
