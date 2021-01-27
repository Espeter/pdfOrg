//
//  EnvironmentController.swift
//  pdfOrg
//
//  Created by Carl Espeter on 17.01.21.
//


import Foundation

class EnvironmentController: ObservableObject {
    
    @Published var presentationMode: Bool = false
    @Published var presentationModeBook: Bool = false
    @Published var presentationModeGig: Bool = false
    @Published var song: Song = Song()
    @Published var tabTag = 1
    @Published var pageIndex: Int = 1
    @Published var pageIndexString: String = "1"
    @Published var book: Book = Book()
    @Published var songInGig: SongInGig = SongInGig()
    @Published var gig: Gig = Gig()
    @Published var updateGigInfoView: Bool = false
}
