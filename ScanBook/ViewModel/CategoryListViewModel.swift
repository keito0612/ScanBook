//
//  CategoryListViewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/12/03.
//


import Foundation
import CoreData

class CategoryListViewModel: ObservableObject{
    @Published var newCategoryName = ""
    @Published var isEditing = false
    @Published var editingCategoryId: NSManagedObjectID?
    @Published var isPresented = false
    @Published var alertText = ""
    var category:Category?
    
    
    
    func addCategory(name: String, context :NSManagedObjectContext) {
          let newCategory = Category(context: context)
          newCategory.id = UUID()
          newCategory.name = name
          newCategory.date = Date()
          do {
              try context.save()
          } catch {
              print("エラー: \(error.localizedDescription)")
          }
      }
    
    func editCategory(category: Category, newName: String, context :NSManagedObjectContext) {
        do {
            category.name = newName
            try context.save()
        } catch {
            print("エラー: \(error.localizedDescription)")
        }
    }
    
    func deleteCategory(category:Category , context :NSManagedObjectContext){
        context.delete(category)
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
}
