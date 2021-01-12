//
//  Persistence.swift
//  pdfOrg
//
//  Created by Carl Espeter on 11.01.21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        
        container = NSPersistentContainer(name: "pdfOrg")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
