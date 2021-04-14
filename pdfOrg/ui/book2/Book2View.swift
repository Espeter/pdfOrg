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
    @State var editMode2: Bool = false
    @State var newName: String = ""
    @State var song: Song?
    @State var page: Int = 1
    
    @State var delitBook: Bool = false
    @State var deleteSongsAlert: Bool = false
    @State var updayitView: Bool = false
    @State var openFile: Bool = false
    @State var bookSettings: Bool = false
    
    @State var error: Bool = false
    @State var error2: Bool = false
    @State var error3: Bool = false
    @State var error4: Bool = false
    @State var errorMessage: String = ""
    @State var errorMessage3: String = ""
    
    @State var infoIsVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                if updayitView{
                    TitelCollectionVeiw(editMode: $editMode2, titel: umwantler(binding: $book.title, fallback: "error_book.titel not faund"), name: $newName)
                        .alert(isPresented: $error) {
                            Alert(title: Text("LS_error" as LocalizedStringKey),
                                  message: error2 ? Text("LS_error Text import \(errorMessage)" as LocalizedStringKey) : Text(errorMessage) ,
                                  primaryButton: .default(Text("LS_More information" as LocalizedStringKey),
                                                          action: {
                                                            infoIsVisible.toggle()
                                                          }),
                                  secondaryButton: .cancel(Text("LS_Oky" as LocalizedStringKey))
                            )
                        }
                } else {
                    TitelCollectionVeiw(editMode: $editMode2, titel: umwantler(binding: $book.title, fallback: "error_book.titel not faund"), name: $newName)
                        .alert(isPresented: $error) {
                            Alert(title: Text("LS_error" as LocalizedStringKey),
                                  message: error2 ? Text("LS_error Text import \(errorMessage)" as LocalizedStringKey) : Text(errorMessage) ,
                                  primaryButton: .default(Text("LS_More information" as LocalizedStringKey),
                                                          action: {
                                                            infoIsVisible.toggle()
                                                          }),
                                  secondaryButton: .cancel(Text("LS_Oky" as LocalizedStringKey))
                            )
                        }
                }
                Text("").alert(isPresented: $error3) {
                    Alert(title: Text("LS_error" as LocalizedStringKey),
                          message: Text("LS_error Text import no Int as number of pages. in row: \(errorMessage3)" as LocalizedStringKey),
                          primaryButton: .default(Text("LS_More information" as LocalizedStringKey),
                                                  action: {
                                                    infoIsVisible.toggle()
                                                  }),
                          secondaryButton: .cancel(Text("LS_Oky" as LocalizedStringKey))
                    )
                }
                Text("")
                .alert(isPresented: $error4) {
                    Alert(title: Text("LS_error" as LocalizedStringKey),
                          message: Text("LS_a page number must be an int" as LocalizedStringKey),
                          dismissButton: .default(Text("LS_Oky" as LocalizedStringKey))
                         )
                }

            }
            EmptyView()
            GeometryReader { geometry in
                if geometry.size.width > geometry.size.height {
                    HStack {
                        Book2ViewView(book: book, page: $page, song: $song, updayitView: $updayitView)
                            .alert(isPresented: $deleteSongsAlert) {
                                Alert(title: Text("LS_delet oll Titels" as LocalizedStringKey),
                                      message: Text("LS_delete titels text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                      primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                                  action: {
                                                                    ec.navigationLinkActive = false
                                                                    book.songs?.forEach{ song in
                                                                        viewContext.delete(song as! Song)
                                                                    }
                                                                    saveContext()
                                                                    updayitView.toggle()
                                                                  }),
                                      secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                                )
                            }
                            .sheet(isPresented: $bookSettings) {
                                BookSetings(book: $book, bookSettings: $bookSettings, updayitView: $updayitView, label: book.label ?? "", id: book.id ?? "error_no Book id", ofSet: book.pageOfset ?? "0", orientation: Int(book.isLandscape), title: book.title ?? "error_no Book name")
                            }
                        BookListOfSongsView(book: $book, updayitView: $updayitView, song: $song, page: $page, editMode: $editMode, error: $error4)
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
                            .sheet(isPresented: $infoIsVisible) {
                                InfoImportIndexView(isVisibel: $infoIsVisible)
                            }
                    }
                }
                else {
                    VStack{
                        Book2ViewView(book: book, page: $page, song: $song, updayitView: $updayitView)
                            .alert(isPresented: $deleteSongsAlert) {
                                Alert(title: Text("LS_delet oll Titels" as LocalizedStringKey),
                                      message: Text("LS_delete titels text \(String(book.songs?.count ?? 0))" as LocalizedStringKey),
                                      primaryButton: .destructive(Text("LS_delit" as LocalizedStringKey),
                                                                  action: {
                                                                    ec.navigationLinkActive = false
                                                                    book.songs?.forEach{ song in
                                                                        viewContext.delete(song as! Song)
                                                                    }
                                                                    saveContext()
                                                                    updayitView.toggle()
                                                                  }),
                                      secondaryButton: .cancel(Text("LS_back" as LocalizedStringKey))
                                )
                            }
                            .sheet(isPresented: $bookSettings) {
                                BookSetings(book: $book, bookSettings: $bookSettings, updayitView: $updayitView, label: book.label ?? "", id: book.id ?? "error_no Book id", ofSet: book.pageOfset ?? "0", orientation: Int(book.isLandscape), title: book.title ?? "error_no Book name")
                            }
                        BookListOfSongsView(book: $book, updayitView: $updayitView, song: $song, page: $page, editMode: $editMode, error: $error4)
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
                            .sheet(isPresented: $infoIsVisible) {
                                InfoImportIndexView(isVisibel: $infoIsVisible)
                            }
                    }
                }
            }
        }.padding(.top, -50)
        .onAppear{
            self.page = 1 - (Int(book.pageOfset ?? "0") ?? 0)
            print("fooo5")
        }
        //        .onDisappear{
        //        //    ec.updatLibrary.toggle()
        //        }
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
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if editMode {
                    Button(action: {
                        viewContext.rollback()
                        editMode = false
                    }, label: {
                        Text("LS_quit" as LocalizedStringKey)
                    })
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if !editMode {
                    Button(action: {editMode = true}, label: {
                        Text("LS_edit" as LocalizedStringKey)
                        Image(systemName:"pencil")
                    })
                }
            }
            ToolbarItem(placement: .primaryAction) {
                if editMode{
                    Button(action: {
                        editMode = false
                        //         ec.updatAllTitelsView.toggle()
                        saveContext()
                    }, label: {
                        Text("LS_done" as LocalizedStringKey)
                    })
                } else {
                    Menu{
                        Button(action: {bookSettings.toggle()}, label: {
                            Text("LS_settings" as LocalizedStringKey)
                            Spacer()
                            Image(systemName:"gear")
                        })
                        Divider()
                        Button(action: {openFile.toggle()}, label: {
                            Text("LS_donlod contents" as LocalizedStringKey)
                            Spacer()
                            Image(systemName:"square.and.arrow.down")
                        })
                        Button(action: {exportDirectory()}, label: {
                            Text("LS_uplod contents" as LocalizedStringKey)
                            //
                            Spacer()
                            Image(systemName:"square.and.arrow.up")
                        })
                        Button(action: {infoIsVisible.toggle()}, label: {
                            Text("LS_how to import" as LocalizedStringKey)
                            Spacer()
                            Image(systemName:"info.circle")
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
        var importErrorMessage: String = ""
        var i = 0
        error2 = false
        error3 = false
        errorMessage3 = ""
        
        do{
            guard url.startAccessingSecurityScopedResource() else {
                return
            }
            //  txt = try NSString(contentsOf: url, encoding: String.Encoding.ascii.rawValue) as String
            txt = try NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) as String
        }  catch {
            importErrorMessage = error.localizedDescription
            print(error)
        }
        
        txt.enumerateLines(invoking: { (line, stop) -> () in
            i = i + 1
            let lineSplit = line.components(separatedBy:";")
            
            print("Int lineSplit[1]: \(lineSplit[1])")
            print("Int lineSplit[2]: \(lineSplit[2])")
            
            if Int(lineSplit[1]) != nil && Int(lineSplit[2]) != nil {
                
                if lineSplit.count == 3 {
                    addSong(name: lineSplit[0], startSide: lineSplit[1], endPage: lineSplit[2], author: nil)
                } else if lineSplit.count == 4 {
                    addSong(name: lineSplit[0], startSide: lineSplit[1],endPage: lineSplit[2], author: lineSplit[3])
                } else {
                    if errorMessage == "" {
                        importErrorMessage =  "die zeilte mit \"\(lineSplit[0])\" hat nicht alle notwenidigen informazionen"
                        error2 = true
                    }
                }
            } else {
                error3 = true
                
              
                
                if errorMessage3 == "" {
                    errorMessage3 = "\(i)"
                } else {
                    errorMessage3 =  errorMessage3 + ", \(i)"
                }
            }
        })
        
        if importErrorMessage != "" {
            
            errorMessage = importErrorMessage
            error = true
        }
        
        url.stopAccessingSecurityScopedResource()
        
        if error3 {
            viewContext.rollback()
        } else {
            saveContext()
            updayitView.toggle()
        }
        
        
        //     ec.updatAllTitelsView.toggle()
        //   ec.updatLibrary.toggle()
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

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
