//
//  Book2View.swift
//  pdfOrg
//
//  Created by Carl Espeter on 19.03.21.
//

import SwiftUI

struct Book2View: View {
    
    @EnvironmentObject var ec : EnvironmentController
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var book: Book
    @State var editMode: Bool = false
    @State var newName: String = ""
    
    @State var page: Int = 1
    
    @State var delitBook: Bool = false
    @State var deleteSongsAlert: Bool = false
    @State var updayitView: Bool = false
    @State var openFile: Bool = false
    @State var bookSettings: Bool = false

    
    var body: some View {
        VStack(alignment: .leading){
            TitelCollectionVeiw(editMode: $editMode, titel: umwantler(binding: $book.title, fallback: "error_book.titel not faund"), name: $newName)
            
            GeometryReader { geometry in
                if geometry.size.width > geometry.size.height {
                    HStack {
                        Book2ViewView(book: book, page: $page)
                            .alert(isPresented: $deleteSongsAlert) {
                            Alert(title: Text("LS_delet oll Titels" as LocalizedStringKey),
                                  message: Text("LS_delete titels text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                  primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                              action: {
                                                                book.songs?.forEach{ song in
                                                                    viewContext.delete(song as! Song)
                                                                }
                                                                saveContext()
                                                                updayitView.toggle()
                                                              }),
                                  secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                            )
                        }
                        BookListOfSongsView(book: $book, updayitView: $updayitView)
                            .alert(isPresented: $delitBook) {
                            Alert(title: Text("LS_delete \"\(book.title!)\"" as LocalizedStringKey),
                                  message: Text("LS_delete Book text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                  primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                              action: {
                                                                ec.navigationLinkActive = false
                                                                viewContext.delete(book)
                                                                saveContext()
                                                              }),
                                  secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                            )
                        }
                    }
                }
                else {
                    VStack{
                        Book2ViewView(book: book, page: $page)
                            .alert(isPresented: $deleteSongsAlert) {
                            Alert(title: Text("LS_delet oll Titels" as LocalizedStringKey),
                                  message: Text("LS_delete titels text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                  primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                              action: {
                                                                book.songs?.forEach{ song in
                                                                    viewContext.delete(song as! Song)
                                                                }
                                                                saveContext()
                                                                updayitView.toggle()
                                                              }),
                                  secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                            )
                        }
                        BookListOfSongsView(book: $book, updayitView: $updayitView)
                            .alert(isPresented: $delitBook) {
                            Alert(title: Text("LS_delete \"\(book.title!)\"" as LocalizedStringKey),
                                  message: Text("LS_delete Book text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                  primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                              action: {
                                                                ec.navigationLinkActive = false
                                                                viewContext.delete(book)
                                                                saveContext()
                                                              }),
                                  secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                            )
                        }                    }
                }
            }
        }.padding(.top, -50)
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.text])
        { (res) in
            do {
                let fileUrl = try res.get()
                importSongs(url: fileUrl)
                
            }
            catch {
                print("error")
            }
        }
        .sheet(isPresented: $bookSettings) {
            BookSetings(book: $book, bookSettings: $bookSettings, label: book.label ?? "-", id: book.id ?? "error_no Book id", ofSet: book.pageOfset ?? "0", orientation: Int(book.isLandscape))
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                
                Menu{
                    Button(action: {print("foo")}, label: {
                        Text("LS_edit" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"pencil")
                    })
                    Button(action: {bookSettings.toggle()}, label: {
                        Text("LS_settings" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"gear")
                    })
                    Button(action: {openFile.toggle()}, label: {
                        Text("LS_donlod contents" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"square.and.arrow.down")
                    })
                    Button(action: {exportDirectory()}, label: {
                        Text("LS_uplod contents" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"square.and.arrow.up")
                    })
                    Divider()
                    Button(action: {deleteSongsAlert.toggle()}, label: {
                        Text("LS_delit contents of Book" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"trash")
                    })
                    Button(action: {delitBook.toggle()}, label: {
                        Text("LS_delit Book" as LocalizedStringKey)
                        Spacer()
                        Image(systemName:"trash")
                    })
                }
                label: {
                    Image(systemName: "ellipsis.circle").padding()
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
    private func saveContext(){
        do{
            try viewContext.save()
        }
        catch {
            let error = error as NSError
            fatalError("error addBook: \(error)")
        }
    }
    private func importSongs(url: URL) {
        
        var txt = String()
        
        do{
            guard url.startAccessingSecurityScopedResource() else {
                return
            }
            //  txt = try NSString(contentsOf: url, encoding: String.Encoding.ascii.rawValue) as String
            txt = try NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) as String
        }  catch {
            print(error)
        }
        
        txt.enumerateLines(invoking: { (line, stop) -> () in
            let lineSplit = line.components(separatedBy:";")
            
            if lineSplit.count == 3 {
                addSong(name: lineSplit[0], startSide: lineSplit[1], endPage: lineSplit[2], author: nil)
            } else {
                addSong(name: lineSplit[0], startSide: lineSplit[1],endPage: lineSplit[2], author: lineSplit[3])
            }
        })
        url.stopAccessingSecurityScopedResource()
        saveContext()
    }
    func addSong(name: String, startSide: String, endPage: String, author: String?) {
        
        let song: Song = Song(context: viewContext)
        
        song.id = UUID()
        song.isFavorit = false
        song.title = name
        song.startPage = startSide
        if endPage != ""{
            song.endPage = endPage
        } else {
            song.endPage = startSide
        }
        song.author = author ?? "n.a."
        
        book.addToSongs(song)
        
   //     saveContext()
    }
    
    private func exportDirectory() {
        
        let text = getDirectory()
        let textData = text.data(using: .utf8)
        let textURL = textData?.dataToFile(fileName: "\(book.title!)_Directory.txt")
        var filesToShare = [Any]()
        filesToShare.append(textURL!)
 
        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)

        if UIDevice.current.userInterfaceIdiom == .pad {
            av.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            av.popoverPresentationController?.sourceRect = CGRect(
                x: UIScreen.main.bounds.width /*/ 2.1*/,
                y: UIScreen.main.bounds.height / 3.2,
                width: 200, height: 200
            )
        }
    }
    
    private func getDirectory() -> String {
        
        var directory = ""
        
        let songsAsArray = getArraySong(book.songs!)
        
        songsAsArray.forEach { song in
            
            directory.append(song.title!)
            directory.append(";")
            directory.append(String(song.startPage ?? "1"))
            directory.append(";")
            directory.append(String(song.endPage ?? "1"))
            
            if song.author != nil {
                directory.append(";")
                directory.append(song.author!)
            }
           
            directory.append("\n")
        }
        
        print(directory)
        return directory
    }
    func getArraySong(_ snSet : NSSet) -> [Song] {
        
        let songs = snSet.allObjects as! [Song]
        
        let sortedSongs = songs.sorted {$0.title ?? "0" < $1.title ?? "0"}
        
        return sortedSongs
    }
}
