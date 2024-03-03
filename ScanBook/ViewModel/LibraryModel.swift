//
//  LibraryModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/03.
//

import Foundation
import CoreData
class LibraryModel :ObservableObject{
    @Published var searchText = ""
    @Published var isAddPresented: Bool = false
    @Published var isEditPresented :Bool = false
    
    func getCategoryStatusText(_ status : Int64 ) -> String{
        switch status {
          case 0:
            return "漫画"
          case 1:
            return "小説"
          default:
            return "書類"
        }
    }
    func dalete(book: BookData , context :NSManagedObjectContext){
        context.delete(book)
        do{
          try context.save()
        }catch{
            print(error)
        }
    }
}
