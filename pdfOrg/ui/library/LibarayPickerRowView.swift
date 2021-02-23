//
//  LibarayPickerRowView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 22.02.21.
//

import SwiftUI

struct LibarayPickerRowView: View {
    
    @State var presentationMode: Int
    
    var body: some View {
        
        HStack{
            
            if presentationMode == 0 {
                Image(systemName: "cart")
             Text("All")
            } else {
                Image(systemName: "tag")
                Text("Label")
            }
        }
    }
}

