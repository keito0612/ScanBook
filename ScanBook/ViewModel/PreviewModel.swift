//
//  PreviewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/03/09.
//

import Foundation
import CoreData
import WithPrevious
class PreviewModel : ObservableObject {
    let bookData:BookData?
//    @Published @WithPrevious<Int> var pageCount = 0
    init(bookData: BookData?) {
        self.bookData = bookData
        if(bookData != nil){
//            self.pageCount = 0
        }
    }
    
    func editPageCount(context : NSManagedObjectContext) {
        do{
//            bookData!.pageCount = Int16(pageCount)
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
}
