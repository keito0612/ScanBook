//
//  Image+CoreDataProperties.swift
//  
//
//  Created by 磯部馨仁 on 2024/12/09.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var id: Int64
    @NSManaged public var image: Data?
    @NSManaged public var memo: String?
    @NSManaged public var bookdata: BookData?

}
