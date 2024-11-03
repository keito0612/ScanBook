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
    @Published var showAlert3:Bool = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var alertType:AlertType = .success
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
                try await deleteAllData()
                for bookData in bookDatas {
                    try await FirebaseServise().addBookData(bookData)
                }
                isLoading = false
                alertType = .success
                alertTitle = "バックアップが完了しました。"
                showAlert = true
            }catch{
                alertType = .success
                alertTitle = "バックアップをすることができませんでした。"
                showAlert = true
                isLoading = false
                print(error)
            }
        }else{
            isLoading = false
        }
    }
    
    @MainActor
    func deleteUser() async {
        isLoading = true
        do{
            try await FirebaseServise().deleteUser()
            isLoading = false
            showAlert = true
            alertType = .success
            alertTitle = "アカウントを削除しました。"
            alertMessage = ""
        }catch{
            isLoading = false
            showAlert = true
            alertTitle = "アカウントを削除できませんでした。"
            alertType = .error
            alertMessage = ""
            print(error)
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
    
    private func deleteAllData() async  throws{
        let deleteDocumentItems  = try await FirebaseServise().db.collection("users").document(FirebaseServise().getUserId()).collection("books").getDocuments().documents
        for document in deleteDocumentItems{
            try await document.reference.delete()
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
