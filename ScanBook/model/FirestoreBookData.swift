//
//  FirestoreBookData.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/18.
//

import Foundation
import FirebaseFirestore
class FirestoreBookData{
    @DocumentID var id:String?
    var reading: Bool?
    var title: String?
    var pageCount:Int?
    var categoryStatus: Int?
    var favorito: Bool
    var date:String
    
    init(reading: Bool, date: String, title: String? = nil, pageCount: Int, categoryStatus: Int, favorito: Bool) {
        self.reading = reading
        self.date = date
        self.title = title
        self.pageCount = pageCount
        self.categoryStatus = categoryStatus
        self.favorito = favorito
    }
}
