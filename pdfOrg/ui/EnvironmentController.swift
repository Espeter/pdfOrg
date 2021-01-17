//
//  EnvironmentController.swift
//  pdfOrg
//
//  Created by Carl Espeter on 17.01.21.
//


import Foundation

class EnvironmentController: ObservableObject {
    
    @Published var presentationMode: Bool = false
    @Published var song: Song = Song()
    @Published var tabTag = 1
    
}
