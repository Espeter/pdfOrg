//
//  AddTitelRowView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 02.03.21.
//

import SwiftUI

struct AddTitelRowView: View {
    
    @State var titel: Song
    @Binding var titelsToBeAdded: [Song]
    
    var body: some View {
        HStack{
            
            if isSelectet() {
                Image(systemName: "checkmark").foregroundColor(Color(UIColor.systemBlue))
                    .font(.title2)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        removeTitel()
                    }
            } else {
                Image(systemName: "plus.circle").foregroundColor(Color(UIColor.systemBlue))
                    .font(.title2)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        addTitel()
                    }
            }
            VStack(alignment: .leading){
                HStack{
                    Text(titel.title ?? "error_no Titel")
                    if titel.isFavorit {
                        Image(systemName: "star.fill").padding(.leading, 10)
                    }
                }.font(.title2)
                HStack{
                    Text(titel.author ?? "error_no author").foregroundColor(Color(UIColor.systemGray))
                    Spacer()
                    Text(titel.book!.title ?? "error_no book title").foregroundColor(Color(UIColor.systemGray))
                }
            }
        }
    }
    
    private func  addTitel() {
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
