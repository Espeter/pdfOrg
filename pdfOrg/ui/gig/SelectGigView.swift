//
//  SelectGigView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 15.01.21.
//

import SwiftUI

struct SelectGigView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var gigs: FetchedResults<Gig>
    
    @Binding var gig: Gig?
    @Binding var showingPopup: Bool

    
    @State private var newGigTitle: String = ""
    
    var body: some View {
        
        VStack{
            
            HStack{
                Text("Title: ").foregroundColor(Color(.black))
                TextField("newGig", text: $newGigTitle)
                Button(action: {
                    addGig()
                }) {
                    Image(systemName: "plus")
                }

               
            }.padding().background(Color(UIColor.systemGray6))
            ScrollView{
                VStack{
                    
                    ForEach(gigs) { gig in
                        
                        HStack{
                            Button(action: {
                                self.gig = gig
                                showingPopup.toggle()
                            }) {
                                Text("\(gig.title ?? "nil")").foregroundColor(Color(.black))
                            }
                            if gig == self.gig {
                                Image(systemName: "checkmark")
                            }
                            Spacer()
                        }
                        Divider()
                    }
                }.padding()
            }.padding(.top, -15).frame(minWidth: 200, maxHeight: 300)
            
        }
    }
    
    func addGig() {
        let newGig = Gig(context: viewContext)
        
        newGig.id = UUID()
        
        if newGigTitle == "" {
            newGigTitle = "new Gig"
        }
        newGig.title = newGigTitle
        saveContext()
        newGigTitle = ""
        
    }
    
    
    private func saveContext(){
        do{
            try viewContext.save()
        }
        catch {
            let error = error as NSError
            fatalError("error addPDF: \(error)")
        }
        
    }
}
