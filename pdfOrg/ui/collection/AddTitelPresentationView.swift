//
//  AddTitelPresentationView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 02.03.21.
//

import SwiftUI

struct AddTitelPresentationView: View {
    
    @State var titel: Song
    @State var isInAddMod: Bool
    @Binding var titelsToBeAdded: [Song]
    
    @State  var book: Book
    @State  var pageIndex: String
    @State  var isLandscape:Bool
    
    var body: some View {
        VStack{
            
            PDFPresentationView(book: $book, pageIndex: $pageIndex, isLandscape: $isLandscape)
            
        }  .navigationBarTitle(titel.title ?? "error_no titel", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: . bottomBar) {
                HStack{
                    Text("\(book.title ?? "error_no Book titel")")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if isInAddMod {
                if isSelectet() {
                    Button(action: {removeTitel()}, label: {
                        Image(systemName: "checkmark")
                    })
                } else {
                    Button(action: {addTitel()}, label: {
                        Image(systemName: "plus.circle")
                    })
                }
                }
            }
        }
    }
    
    private func addTitel() {
        titelsToBeAdded.append(titel)
    }
    
    private func removeTitel() {
        
        var i = 0
        
        titelsToBeAdded.forEach{ titelToeAdded in
            
            if titelToeAdded == titel {
                titelsToBeAdded.remove(at: i)
            }
            i = i + 1
        }
    }
    
    private func isSelectet() -> Bool {
        
        var isSelectet: Bool = false
        
        titelsToBeAdded.forEach{ titelInCollection in
            
            if titelInCollection == titel {
                isSelectet = true
            }
        }
        return isSelectet
    }
}
