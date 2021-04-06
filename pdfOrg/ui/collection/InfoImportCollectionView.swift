//
//  InfoImportCollectionView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 06.04.21.
//

import SwiftUI

struct InfoImportCollectionView: View {
    
    @Binding var isVisibel: Bool
    
    var body: some View {
        NavigationView(){
        Text("ToDo: how to import text")
            .navigationBarTitle("LS_how to import Collectin" as LocalizedStringKey)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {isVisibel.toggle()}, label: {
                        Text("LS_quit" as LocalizedStringKey)
                    })
                }
            }
        }
    }
}
