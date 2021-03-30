//
//  BookSetings.swift
//  pdfOrg
//
//  Created by Carl Espeter on 20.03.21.
//

import SwiftUI

struct BookSetings: View {
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(sortDescriptors: [])
    var books: FetchedResults<Book>
    
    @Binding var book: Book
    @Binding var bookSettings: Bool
    @Binding var updayitView: Bool
    
    @State var label: String
    @State var id: String
    @State var ofSet: String
    @State var orientation: Int
    @State var title: String
    
    let orientations = ["rectangle.portrait", "rectangle"]
    
    @State var idAlert: Bool = false
    
    var body: some View {
        NavigationView(){
            Form{
                Section{
                    HStack{
                        Text("LS_Book Name: " as LocalizedStringKey)
                        TextField(book.title ?? "error_no titel", text: $title)
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                }
                Section{
                    VStack{
                        HStack{
                            Text("LS_Book Id: " as LocalizedStringKey)
                            TextField(book.id ?? "error_no id", text: $id)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        HStack{
                            Text("LS_Info Text of Book id" as LocalizedStringKey).font(.footnote)//.foregroundColor(Color(UIColor.systemGray2))
                            Spacer()
                        }
                    }
                    VStack{
                        HStack{
                            Text("LS_Book Label: " as LocalizedStringKey)
                            TextField(book.label ?? "error_no label", text: $label)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                        HStack{
                            Text("LS_Info Text of Book Label" as LocalizedStringKey).font(.footnote)//.foregroundColor(Color(UIColor.systemGray2))
                            Spacer()
                        }
                    }
                }
                Section{
                    HStack{
                        Text("LS_Orientation : " as LocalizedStringKey)
                        
                        Picker("", selection: $orientation){
                            
                            ForEach(0 ..< orientations.count, id: \.self) {
                                Image(systemName: orientations[$0])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                }
                Section{
                    VStack{
                        HStack{
                            Text("LS_page of set: " as LocalizedStringKey)
                            Picker("", selection: $ofSet) {
                                ForEach(getNumbers(), id: \.self) { number in
                                    Text("\(number)")
                                }
                            }.pickerStyle(WheelPickerStyle())
                            .frame( height: 100, alignment: .center)
                            
                            Text("LS_Info Text of Page of Set" as LocalizedStringKey)
                                .font(.footnote)
                                .frame( height: 100, alignment: .bottom)
                        }
                    }
                }
                Section{
                    HStack{
                        Text("LS_Book pdf Name: " as LocalizedStringKey)
                        Text("\(book.pdfTitle ?? "error_No pdfTitel")")
                    }
                    HStack{
                        Text("LS_Numer of songs: " as LocalizedStringKey)
                        Text("\(book.songs?.count ?? 0)")
                    }
                }
            }
            .alert(isPresented: $idAlert) {
                Alert(title: Text("LS_id already exists" as LocalizedStringKey),
                      message: Text("LS_this ID already exists" as LocalizedStringKey),
                      dismissButton: .cancel(Text("LS_Oky" as LocalizedStringKey))
                )
            }
            .navigationBarTitle("LS_settings" as LocalizedStringKey)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {quit()}, label: {
                        Text("LS_quit" as LocalizedStringKey)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {done()}, label: {
                        Text("LS_save" as LocalizedStringKey)
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text(book.title ?? "error_no Book Teitel")
                }
            }
        }
    }
    private  func quit() {
        bookSettings = false
    }
    private  func done() {
        
        if idDoesNotExist() {
            idAlert = true
        } else {
            self.book.id = id
            self.book.label = label
            self.book.isLandscape = Int64(orientation)
            self.book.pageOfset = ofSet
            self.book.title = title

            saveContext()
            bookSettings = false
            updayitView.toggle()
        }
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
    
    private func idDoesNotExist() -> Bool {
        
        var idDoesNotExist = false
        
        books.forEach{ book in
            
            if book.id == id && book != self.book{
                idDoesNotExist = true
            }
        }
        
        return idDoesNotExist
    }
    
    private func getNumbers() -> [String] {
        
        var nambers: [String] = []
        
        let array = Array(-500...500)
        
        array.forEach { i in
            nambers.append("\(i)")
        }
        return nambers
    }
    
}
