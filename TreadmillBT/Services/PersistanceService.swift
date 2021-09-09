//
//  PersistanceService.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 26/05/2021.
//

import CoreData

struct PersistenceService {
    static let shared = PersistenceService()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TreadmillBT")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription.url)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    // For PREVIEW purposes
    static var preview: PersistenceService = {
        let result = PersistenceService(inMemory: true)
        let container = result.container
        let viewContext = result.container.viewContext
        
        let run = Run(context: viewContext)
        run.start = Date()
        run.end = Date().addingTimeInterval(60*60)
        run.logs = [[253, 16, 161, 2, 25, 25, 0, 0, 0, 99, 47, 1, 157, 11, 76, 0, 108, 254]]
        
        let run2 = Run(context: viewContext)
        run2.start = Date().addingTimeInterval(-3*50*60)
        run2.end = Date().addingTimeInterval(-2*70*60)
        run2.logs = [[253, 16, 161, 2, 31, 31, 0, 0, 0, 45, 32, 2, 121, 11, 76, 0, 108, 254]]
        
        try! viewContext.save()
        
        return result
    }()
}
