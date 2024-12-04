//
//  Persistence.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/03.
//

import Foundation
import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let imageArray:[UIImage] = [
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
            UIImage(named: "preview_image")!,
        ]
        let categorys:[String] = ["ノート", "漫画","書類","小説"]
        for i in 0..<10  {
            let viewContext = result.container.viewContext
            let BookData = BookData(context: viewContext)
            BookData.id = UUID()
            BookData.coverImage = Data.init()
            BookData.images = imageArray.encode()
            
            if(i == 1 ){
                BookData.coverImage =  UIImage(named: "preview_image")?.jpegData(compressionQuality: 1)
            }
            BookData.categoryStatus = "書類"
            BookData.favorito = true
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
        }
        for categoryData  in categorys {
            let viewContext = result.container.viewContext
            let category = Category(context: viewContext)
            category.id = UUID()
            category.name = categoryData
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer
    let iCloud:Bool = UserDefaults.standard.bool(forKey: "iCloud")

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ScanBook")
        if inMemory {
            let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("ScanBook.sqlite")
            container.persistentStoreDescriptions.first!.url = storeURL
        }
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("\(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        if(iCloud){
            do{
                try container.viewContext.setQueryGenerationFrom(.current)
            }catch {
                assertionFailure("###\(#function): Failed to pin viewContext to the current generation:\(error)")
            }
        }
    }
}
