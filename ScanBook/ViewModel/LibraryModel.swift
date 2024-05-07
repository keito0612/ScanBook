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
    @Published var isEditPresented: Bool = false
    @Published var isPreviewPresented: Bool = false
    @Published var snackText:String = ""
    @Published var showSnack:Bool = false
    
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
    
    func getCategoryStatusNumber(_ status: String) -> String{
        switch status {
        case "漫画":
            return "0"
        case "小説":
            return "1"
        case "書類":
            return "2"
        default:
            return "3"
        }
    }
    
    func editFavorite(book: BookData, value: Bool, context :NSManagedObjectContext){
        do{
            book.favorito = value
            try context.save()
        }catch{
            print(error.localizedDescription)
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
