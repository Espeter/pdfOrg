//
//  SongRowView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 14.01.21.
//

import SwiftUI

struct SongRowView: View {
    
    @State var song: Song
    @Binding var editMode: Bool
    @Binding var page: Int
    @Binding var selectedSong: Song?
    
    
    var body: some View {
        
        if editMode {
            Button(action: {
                page = 0
                page = Int(song.startPage ?? "0") ?? 0
                selectedSong = song
            }) {
                HStack{
                    TextField("\(song.title ?? "nil")", text: umwantler(binding: $song.title, fallback: "error"))
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(15.0)
                    Spacer()
                    TextField("\(song.startPage ?? "nil")", text: umwantler(binding: $song.startPage, fallback: "error"))
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(15.0)
                    Text("-")
                    TextField("\(song.endPage ?? "")", text: umwantler(binding: $song.endPage, fallback: ""))
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(15.0)
                    Spacer()
                    TextField("\(song.author ?? "nil")", text: umwantler(binding: $song.author, fallback: "error"))
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(15.0)
                }
            }
        } else {
            Button(action: {
                page = 0
                page = Int(song.startPage ?? "0") ?? 0
                selectedSong = song
            }) {
                HStack{
                    Text("\(song.title ?? "nil")").frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    HStack{
                    Text("\(song.startPage ?? "nil")")
                    if song.endPage != nil && song.endPage != song.startPage{
                        Text("-")
                        Text("\(song.endPage ?? "nil")")
                    }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    HStack{
                    Text("\(song.author ?? "nil")").frame(maxWidth: .infinity, alignment: .leading)
                  //  Spacer()
                    if song.isFavorit {
                        Image(systemName: "star.fill").foregroundColor(Color(UIColor.systemGray))
                    }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    // Qelle: https://forums.swift.org/t/promoting-binding-value-to-binding-value/31055
    func umwantler<T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding(get: {
            binding.wrappedValue ?? fallback
        }, set: {
            binding.wrappedValue = $0
        })
    }
}
