//
//  Titles.swift
//  pdfOrg
//
//  Created by Carl Espeter on 28.02.21.
//

import Foundation
import SwiftUI

class Titles {
    
    private var songs: FetchedResults<Song>
    public var array: [Song]
    //    private var viewContext: NSManagedObjectContext  {
    //        return PersistenceController.shared.container.viewContext
    //    }
    
    init(songs: FetchedResults<Song>) {
        
        self.songs = songs
        self.array = []
        
        songs.forEach{ song in
            array.append(song)
        }
        array.sort {
            $0.title ?? "" < $1.title ?? ""
        }
    }
    
    func getSegmentTitles(by alphabet: [String] ) -> [String: [Song]] {
        
        var dictionary: [String: [Song]] = [:]
        
        alphabet.forEach{ char in
            dictionary[char] = []
        }
        self.array.forEach{ song in
            let firstLetter = song.title?.first?.lowercased()
            
            if (dictionary[firstLetter!] != nil) {
                dictionary[firstLetter!]?.append(song)
            } else {
                dictionary["#"]?.append(song)
            }
        }
        return dictionary
    }
    
    func getSearchResult(searchTerms: String) -> [Song] {
        
        var titles: [Song] = []
        
        array.forEach { song in
            
            var splitSearchText = searchTerms.components(separatedBy: " ")
            let splitSearchTextCount = splitSearchText.count
            var comparedWords = 0
            
            let splitTitle: [String]
            if  song.title != nil {
                splitTitle = song.title!.components(separatedBy: " ")
            } else {
                splitTitle = [""]
            }
            
            let splitAuthor: [String]
            if   song.author != nil {
                splitAuthor = song.author!.components(separatedBy: " ")
            } else {
                splitAuthor = [""]
            }
            
            splitTitle.forEach{ titleWord in
                
                splitSearchText.forEach{ search in
                    
                    if titleWord.contains(search) {
                        comparedWords = comparedWords + 1
                        splitSearchText.remove(at: splitSearchText.firstIndex(of: search)!)
                    }
                }
            }
            
            splitAuthor.forEach{ authorWord in
                
                splitSearchText.forEach{ search in
                    
                    if authorWord.contains(search) {
                        comparedWords = comparedWords + 1
                        splitSearchText.remove(at: splitSearchText.firstIndex(of: search)!)
                    }
                }
            }
            
            if splitSearchText.last == "" {
                comparedWords = comparedWords + 1
            }
            
            if comparedWords >= splitSearchTextCount {
                titles.append(song)
            }
        }
        return titles
    }
}


