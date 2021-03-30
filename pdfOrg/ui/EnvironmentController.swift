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
    @Published var currentBook: Book? = Book()
    @Published var navigationLinkActive: Bool = false
    @Published var showingPopupAppSong: Bool = false
    @Published var gBookID: String = "supergeheimmesBuchDasNurIchKennenDarf42MahahahahahahaGeheim"
    @Published var presentationModeLibrary: Int = 0
    @Published var updatLibrary: Bool = false
    
    @Published var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","#"]
    
    @Published var titelName: String = ""
    @Published var startPage: String = ""
    @Published var endPage: String = ""
    @Published var label: String = ""
    

}
