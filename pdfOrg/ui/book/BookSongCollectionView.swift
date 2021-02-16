//
//  BookSongCollectionView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI

struct BookSongCollectionView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var ec : EnvironmentController

    @ObservedObject var book: Book
    @State var editMode: Bool = false
    @Binding var page: Int
    @Binding var selectedSong: Song?
    @Binding var updateView: Bool
    @State var deleteSongsAlert: Bool = false

    @Binding var showingPopup: Bool
    @State var openFile = false

    
    var body: some View {
        VStack{
            HStack{
                if editMode {
                    Button(action: {
                            saveContext()
                        editMode = false
                    }) {
                            Text("done").padding()
                    }
                    
                }
                if showingPopup {
                    Text("")
                }
                Spacer()
//                Text("title").frame(maxWidth: .infinity, alignment: .leading)
//
//                Text("page").frame(maxWidth: .infinity, alignment: .leading)
//
//                Text("author")//.frame(maxWidth: .infinity/*, alignment: .leading*/)
                Button(action: {
                //    showingPopup.toggle()
                    showingPopup = true
                    ec.showingPopupAppSong = true
                }) {
                    Image(systemName: "plus").padding()
                        .popover(isPresented:  $showingPopup) {
                         
                            AddSongPopoverView(book: book, showingPopup: $showingPopup, currentBook: $page)
//                            Text("showingPopup: \(String(showingPopup))").onTapGesture {
//                                print("showingPopup: \(String(showingPopup))")
//                            }
                        }
              //  }
            }
                Button(action: {
                    openFile.toggle()
                }) {
                    Image(systemName: "square.and.arrow.down")
                }
                Button(action: {
                    deleteSongsAlert.toggle()
                }) {
                    Image(systemName: "trash").padding()
                        //.padding()
                        .alert(isPresented: $deleteSongsAlert) {
                        Alert(title: Text("delete all Songs"),
                              message: Text("Bist du dir sicher, dass du alle \(book.songs?.count ?? 0) Lieder löschen möchtest?"),
                              primaryButton: .destructive(Text("delete"),
                                                          action: {
                                                            getArraySong(book.songs!).forEach { song in
                                                                viewContext.delete(song)
                                                            }
                                                            saveContext()
                                                          }),
                              secondaryButton: .cancel(Text("back"))
                        )
                    }
                }
            
           
            }/*.padding()*/.frame(maxWidth: .infinity, alignment: .trailing).background(Color(UIColor.systemGray6))//, alignment: .leading)
            ScrollViewReader { scroll in
            List() {
                
                ForEach(getArraySong(book.songs!)) { song in
                    SongRowView(song: song, editMode: $editMode, page: $page, selectedSong: $selectedSong, updateView: $updateView)
                }.onDelete(perform: deleteSong)
            }
            }
        }
         .background(Color(UIColor.white))
        .cornerRadius(15.0)
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.text])
        { (res) in
            do {
                let fileUrl = try res.get()
                importSongs2(url: fileUrl)
                
            }
            catch {
                print("error")
            }
            
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
    }
    
    private func importSongs2(url: URL) {
        
      //  var txt = StreamReader(path: url)
        
        if let aStreamReader = StreamReader(path: url) {
            defer {
                for line in aStreamReader {
                    let lineSplit = line.components(separatedBy:";")
                    
                    if lineSplit.count == 3 {
                        addSong(name: lineSplit[0], startSide: lineSplit[1], endPage: lineSplit[2], author: nil)
                    } else {
                        addSong(name: lineSplit[0], startSide: lineSplit[1],endPage: lineSplit[2], author: lineSplit[3])
                    }
                }
            }
            while aStreamReader.nextLine() != nil {
                for line in aStreamReader {
                    let lineSplit = line.components(separatedBy:";")
                    
                    if lineSplit.count == 3 {
                        addSong(name: lineSplit[0], startSide: lineSplit[1], endPage: lineSplit[2], author: nil)
                    } else {
                        addSong(name: lineSplit[0], startSide: lineSplit[1],endPage: lineSplit[2], author: lineSplit[3])
                    }
                }
            }
        }

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
    
    func getArraySong(_ snSet : NSSet) -> [Song] {
        
        let songs = snSet.allObjects as! [Song]
        
        let sortedSongs = songs.sorted {$0.title ?? "0" < $1.title ?? "0"}
        
        return sortedSongs
    }
    
    private func deleteSong(offsets: IndexSet) {
        withAnimation {
            offsets.map {getArraySong(book.songs!)[$0]}.forEach(viewContext.delete)
            saveContext()
        }
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
}





class StreamReader  {

    let encoding : String.Encoding
    let chunkSize : Int
    var fileHandle : FileHandle!
    let delimData : Data
    var buffer : Data
    var atEof : Bool

    init?(path: URL, delimiter: String = "\n", encoding: String.Encoding = .utf8,
          chunkSize: Int = 4096) {

     //   guard let fileHandle = FileHandle(forReadingAtPath: path),
        
        do{
            guard let fileHandle = try? FileHandle(forReadingFrom: path),

            let delimData = delimiter.data(using: encoding) else {
                return nil
        }
        
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = delimData
        self.buffer = Data(capacity: chunkSize)
        self.atEof = false
        }
    }

    deinit {
        self.close()
    }

    /// Return next line, or nil on EOF.
    func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")

        // Read data chunks from file until a line delimiter is found:
        while !atEof {
            if let range = buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEof = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }

    /// Start reading from the beginning of file.
    func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEof = false
    }

    /// Close the underlying file. No reading must be done after calling this method.
    func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}

extension StreamReader : Sequence {
    func makeIterator() -> AnyIterator<String> {
        return AnyIterator {
            return self.nextLine()
        }
    }
}
