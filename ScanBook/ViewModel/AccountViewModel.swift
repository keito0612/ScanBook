//
//  AccountViewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/19.
//

import Foundation
import CoreData

class AccountViewModel: ObservableObject{
    @Published var showAlert:Bool = false
    @Published var showAlert2:Bool = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    init(){
        FirebaseServise().addStateDidChangeListener(completion: { isAuthenticated  in
            self.isAuthenticated = isAuthenticated
        })
    }
    @MainActor
    func backUp() async{
        isLoading = true
        let bookDatas :Array<BookData> = getAllData()
        if(!bookDatas.isEmpty){
            do{
                for bookData in bookDatas {
                    try await FirebaseServise().addBookData(bookData)
                }
                isLoading = false
            }catch{
                isLoading = false
                print("エラーが発生しました。")
            }
        }else{
            isLoading = false
        }
    }
    
    private func getAllData() -> [BookData]{
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        
        let request = NSFetchRequest<BookData>(entityName: "BookData")
        
        do {
            let bookDatas = try context.fetch(request)
            return bookDatas
        }
        catch {
            fatalError()
        }
    }
    
    
    func signOut() {
        do{
            try FirebaseServise().signOut()
        }catch let error as NSError {
            print(error)
        }
    }
}
