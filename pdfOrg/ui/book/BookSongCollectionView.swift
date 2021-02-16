//
//  BookSongCollectionView.swift
//  pdfOrg
//
//  Created by Carl Espeter on 13.01.21.
//

import SwiftUI
import UIKit

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
                    Image(systemName: "plus")
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
                    Image(systemName: "square.and.arrow.down").padding()
                }
                Button(action: {
                    // upLod Inhalsverzeichnis
                    exportDirectory()
                }) {
                    Image(systemName: "square.and.arrow.up")
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
                x: UIScreen.main.bounds.width / 2.1,
                y: UIScreen.main.bounds.height / 1.5,
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
    private func importSongs2(url: URL) {
        
      //  var txt = StreamReader(path: url)
        print("importSongs2 <------")
        if let aStreamReader = StreamReader(path: url) {
            print("aStreamReader")
            defer {
                for line in aStreamReader {
                    print(line)
                    let lineSplit = line.components(separatedBy:";")
                    
                    if lineSplit.count == 3 {
                        addSong(name: lineSplit[0], startSide: lineSplit[1], endPage: lineSplit[2], author: nil)
                    } else {
                        addSong(name: lineSplit[0], startSide: lineSplit[1],endPage: lineSplit[2], author: lineSplit[3])
                    }
                }
            }
            while aStreamReader.nextLine() != nil {
                print("aStreamReader")
                for line in aStreamReader {
                    print(line)
                    let lineSplit = line.components(separatedBy:";")
                   
                    if lineSplit.count == 3 {
                        addSong(name: lineSplit[0], startSide: lineSplit[1], endPage: lineSplit[2], author: nil)
                    } else {
                        addSong(name: lineSplit[0], startSide: lineSplit[1],endPage: lineSplit[2], author: lineSplit[3])
                    }
                }
            }
        }
     
        print("saveContext()")
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




//TODO: Quelle: https://stackoverflow.com/questions/24581517/read-a-file-url-line-by-line-in-swift
class StreamReader  {

    let encoding : String.Encoding
    let chunkSize : Int
    var fileHandle : FileHandle!
    let delimData : Data
    var buffer : Data
    var atEof : Bool

    init?(path: URL, delimiter: String = "\n", encoding: String.Encoding = .utf8,
          chunkSize: Int = 4096) {
print("init?")
     //   guard let fileHandle = FileHandle(forReadingAtPath: path),
        
        do{
            print("do")
            guard let fileHandle = try? FileHandle(forReadingFrom: path),
                
            let delimData = delimiter.data(using: encoding) else {
                print("nil")
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

//TODO: Quelle: https://stackoverflow.com/questions/35851118/how-do-i-share-files-using-share-sheet-in-ios
extension Data {

    /// Data into file
    ///
    /// - Parameters:
    ///   - fileName: the Name of the file you want to write
    /// - Returns: Returns the URL where the new file is located in NSURL
    func dataToFile(fileName: String) -> NSURL? {

        // Make a constant from the data
        let data = self

        // Make the file path (with the filename) where the file will be loacated after it is created
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            // Write the file from data into the filepath (if there will be an error, the code jumps to the catch block below)
            try data.write(to: URL(fileURLWithPath: filePath))

            // Returns the URL where the new file is located in NSURL
            return NSURL(fileURLWithPath: filePath)

        } catch {
            // Prints the localized description of the error from the do block
            print("Error writing the file: \(error.localizedDescription)")
        }

        // Returns nil if there was an error in the do-catch -block
        return nil

    }
    
    /// Get the current directory
    ///
    /// - Returns: the Current directory in NSURL
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }

}
