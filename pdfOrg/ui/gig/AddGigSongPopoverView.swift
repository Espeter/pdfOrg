//
//  AddGigSongPopoverView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 15.01.21.
//

import SwiftUI

struct AddGigSongPopoverView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var songs: FetchedResults<Song>
    
    var body: some View {
        VStack{
            ForEach(songs) { song in
                HStack{
                Text("\(song.title ?? "nil")").foregroundColor(Color(.black))
                    Text("\(song.author ?? "nil")").foregroundColor(Color(.black))

                }
                Divider()
            }
        }.padding()
    }
}

struct AddGigSongPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        AddGigSongPopoverView()
    }
}
