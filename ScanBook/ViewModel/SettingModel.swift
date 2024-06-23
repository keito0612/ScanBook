//
//  Setting.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/10.
//

import Foundation
import CoreData
import SwiftUI

class SettingModel: ObservableObject  {
    @Published var showAlert:Bool = false
    @Published var showAlert2:Bool = false
    @Published var showAlert3:Bool = false
    
    var alertTitle:String = ""
    var alertMessage:String = ""
    
    func deleteAllBookDatas(bookDatas: FetchedResults<BookData>,context:NSManagedObjectContext) {
        withAnimation {
           bookDatas.forEach(context.delete)
            do {
                try context.save()
                showAlert3 = true
                alertTitle = "削除しました。"
                alertMessage = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
