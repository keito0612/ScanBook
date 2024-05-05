//
//  Persistence.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/03.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let BookData = BookData(context: viewContext)
        BookData.id = UUID()
        BookData.coverImage = Data.init()
        BookData.images = ""
        BookData.categoryStatus = 2
        BookData.favorito = false
        BookData.date = Date()
        BookData.reading = true
        BookData.pageCount = 0
        BookData.title = "タイトル"
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ScanBook")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("\(error), \(error.userInfo)")
              fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
