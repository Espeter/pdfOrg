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
    
    @Binding var gig: Gig
    @Binding var showingPopup: Bool

    @State private var newGigTitle: String = ""
    
    var body: some View {
        
        VStack{

            
            HStack{
                Text("Title: ").foregroundColor(Color(.black))
                TextField("New Collection", text: $newGigTitle)
                Button(action: {
                    addGig()
                }) {
                    Image(systemName: "plus")
                }


            }.padding().background(Color(UIColor.systemGray6))
            List{
              //  VStack{

                    ForEach(getArrayGigs()) { gigO in

                        HStack{
                            Button(action: {
                                self.gig = gigO
                                showingPopup.toggle()
                                textPrintOllgigTitel()
                            }) {
                                Text("\(gigO.title ?? "nil")").foregroundColor(Color(.black))
                            }
                            if gigO == self.gig {
                                Image(systemName: "checkmark")
                            }
                            Spacer()
                        }
                   //     Divider()
                    }.onDelete(perform: deleteGig)
                //}.padding()
            }.padding(.top, -15)
            
        }.frame(minWidth: 200, minHeight: 300)
    }
    
    private func deleteGig(offsets: IndexSet) {
        withAnimation {
            offsets.map {getArrayGigs()[$0]}.forEach(viewContext.delete)
            saveContext()
        }
    }

    
    
    func textPrintOllgigTitel() {
        gigs.forEach{ gig in
            
        //    print(gig.title)
            
        }
    }
    
    func getArrayGigs() -> [Gig] {
        var songsArray: [Gig] = []
        
        gigs.forEach{ gig in
            songsArray.append(gig)
        }
        
        songsArray.sort {
            $0.title! < $1.title!
        }
        print(songsArray)
        return songsArray
    }
    
    func addGig() {
        let newGig = Gig(context: viewContext)
        
        newGig.id = UUID()
        
        if newGigTitle == "" {
            newGigTitle = "new Collection"
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
