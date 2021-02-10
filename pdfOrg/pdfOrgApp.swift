//
//  pdfOrgApp.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import SwiftUI

@main
struct pdfOrgApp: App {
    @StateObject private var store = Store()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(EnvironmentController())
                .environmentObject(store)
        }
    }
}
