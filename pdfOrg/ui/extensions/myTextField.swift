//
//  myTextField.swift
//  pdfOrg
//
//  Created by Carl Espeter on 30.03.21.
//

import SwiftUI

struct myTextField: View {
    
//    @Binding var newText: String
    @Binding var text: String
    
    var body: some View {
        TextField(text, text: $text).foregroundColor(Color(UIColor.systemGray))
    }
}
