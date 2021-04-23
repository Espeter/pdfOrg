//
//  pdfOrgApp.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI

@main
struct pdfOrgApp: App {
 ////   @StateObject private var store = Store()
//    @FetchRequest(sortDescriptors: [])
//    private var songs: FetchedResults<Song>
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(EnvironmentController())
                .environmentObject(EnvironmentControllerLibrary())
                .environmentObject(OrientationInfo())
      ////          .environmentObject(store)
        }
    }
}
