//
//  BookData+CoreDataProperties.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/03.
//
//

import Foundation
import CoreData


extension BookData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookData> {
        return NSFetchRequest<BookData>(entityName: "BookData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var coverImage: Data?
    @NSManaged public var reading: Bool
    @NSManaged public var date: Date?
    @NSManaged public var images: String?
    @NSManaged public var title: String?
    @NSManaged public var pageCount:Int16
    @NSManaged public var categoryStatus: Int64
    @NSManaged public var favorito: Bool

}

extension BookData : Identifiable {
    
}
