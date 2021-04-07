//
//  EnvironmentControllerBook.swift
//  pdfOrg
//
//  Created by Carl Espeter on 07.04.21.
//

import Foundation


class EnvironmentControllerBook: ObservableObject {
    
    @Published var titelName: String = ""
    @Published var startPage: String = ""
    @Published var endPage: String = ""
    @Published var label: String = ""
}
