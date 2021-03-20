//
//  TitelCollectionVeiw.swift
//  pdfOrg
//
//  Created by Carl Espeter on 09.03.21.
//

import SwiftUI

struct TitelCollectionVeiw: View {
    
    @Binding var editMode: Bool
    @Binding var titel: String
//    @State var titel: String
    @Binding var name: String
    
    @State var alertisPresented: Bool = false
    
    var body: some View {
        if editMode {
            
            TextField("\(titel)", text: $name).font(.largeTitle).padding(.leading, 20).padding(.bottom, -1).foregroundColor(Color(UIColor.systemGray))
  //          Text("\(titel)").bold().font(.largeTitle).padding(.leading, 20).padding(.bottom, -1)
            
            
//          SearchBar(text: $name)
//            HStack{
//            Text("\(titel)").bold().font(.largeTitle).padding(.leading, 20).padding(.bottom, -1)
//                Button(action: {alertisPresented.toggle()}, label: {
//                    HStack{
//                        Image(systemName: "pencil.circle")
//                    Text("edit Name" as LocalizedStringKey)
//                    }
//                }).padding(.leading, 20)
//            }
        } else {
   //         SearchBar(text: $name)
            Text("\(titel)").bold().font(.largeTitle).padding(.leading, 20).padding(.bottom, -1)
        }
//        .alert(isPresented: $alertisPresented) {
//            Alert(title: Text("LS_rename: %@" as LocalizedStringKey),
//                  message:
//                    TextField("\(titel)", text: $name)
//                  ,
//                  primaryButton: .cancel(Text("LS_back" as LocalizedStringKey)),
//                  secondaryButton: .default(
//                    Text("LS_done" as LocalizedStringKey),
//                    action: {
//
//                       print("\(name)")
//                    })
//            )
//        }
    }
}
