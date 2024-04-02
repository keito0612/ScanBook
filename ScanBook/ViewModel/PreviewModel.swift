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
    @WithPrevious var pageCount :Int = 0
    init(bookData: BookData?) {
        self.bookData = bookData
        if(bookData != nil){
            pageCount = Int(bookData!.pageCount)
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
