//
//  InfoImportIndexView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 06.04.21.
//

import SwiftUI

struct InfoImportIndexView: View {
    
    @Binding var isVisibel: Bool
    
    var body: some View {
        NavigationView(){
            VStack{
            Text("LS_how to import Text" as LocalizedStringKey).font(.title3).padding()
            Spacer()
            }
            .navigationBarTitle("LS_how to import" as LocalizedStringKey)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {isVisibel.toggle()}, label: {
                        Text("LS_back" as LocalizedStringKey)
                    })
                }
            }
        }
    }
}
