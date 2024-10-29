//
//  FirestoreBookData.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/18.
//

import Foundation
import FirebaseFirestore
struct FirestoreBookData:Codable{
    @DocumentID var id:String?
    var coverImage: String?
    var reading: Bool?
    var images:Array<String>?
    var title: String?
    var pageCount:Int?
    var categoryStatus: Int?
    var favorito: Bool?
    var date: String?
}
