//
//  Category+CoreDataProperties.swift
//  
//
//  Created by 磯部馨仁 on 2024/11/28.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}
