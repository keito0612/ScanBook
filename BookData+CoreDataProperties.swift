//
//  BookData+CoreDataProperties.swift
//  
//
//  Created by 磯部馨仁 on 2024/12/05.
//
//

import Foundation
import CoreData


extension BookData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookData> {
        return NSFetchRequest<BookData>(entityName: "BookData")
    }

    @NSManaged public var categoryStatus: String?
    @NSManaged public var coverImage: Data?
    @NSManaged public var date: Date?
    @NSManaged public var favorito: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var pageCount: Int16
    @NSManaged public var reading: Bool
    @NSManaged public var title: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension BookData {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
