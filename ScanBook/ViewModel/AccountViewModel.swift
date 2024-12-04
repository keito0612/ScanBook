//
//  AccountViewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/19.
//

import Foundation
import CoreData
import SwiftUI

class AccountViewModel: ObservableObject{
    @Published var showAlert:Bool = false
    @Published var showAlert2:Bool = false
    @Published var showAlert3:Bool = false
    @Published var showSignOutAlert:Bool = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var alertType:AlertType = .success
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var loadingMesssage = ""
    
    init(){
        FirebaseServise().addStateDidChangeListener(completion: { isAuthenticated  in
            self.isAuthenticated = isAuthenticated
        })
    }
    @MainActor
    func backUp() async{
        loadingMesssage = "バックアップ中..."
        isLoading = true
        let bookDatas :Array<BookData> = getAllData()
        if(!bookDatas.isEmpty){
            do{
                try await deleteAllData()
                try await FirebaseServise().addBookData(bookDatas)
                isLoading = false
                alertType = .success
                alertTitle = "バックアップが完了しました。"
                showAlert = true
            }catch{
                alertType = .error
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
    
    @MainActor
    func getBackUpData(context :NSManagedObjectContext) async {
        var firestoreBookDataList: Array<FirestoreBookData> = []
        loadingMesssage = "データを復元中..."
        isLoading = true
        do{
            deleteAllBookDatas(context: context)
            let documents = try await FirebaseServise().db.collection("users").document(FirebaseServise().getUserId()).collection("books").getDocuments().documents
            firestoreBookDataList =  documents.compactMap { try? $0.data(as: FirestoreBookData.self)}
            addBookData(firestoreBookDataList: firestoreBookDataList, context: context)
            isLoading = false
            alertTitle = "データを復元しました。"
            alertMessage = ""
            alertType = .success
            showAlert = true
        }catch{
            isLoading = false
            alertTitle = "データの復元に失敗しました。"
            alertMessage = "もう一度お試しください。"
            alertType = .error
            showAlert = true
            print(error)
        }
    }
    
    private func addBookData( firestoreBookDataList:Array<FirestoreBookData>,context :NSManagedObjectContext){
        do{
            if(!firestoreBookDataList.isEmpty){
                for bookData in firestoreBookDataList {
                    let newBookData = BookData(context: context)
                    newBookData.id = UUID()
                    newBookData.favorito = bookData.favorito!
                    newBookData.reading = bookData.reading!
                    newBookData.title = bookData.title
                    if(!bookData.coverImage!.isEmpty){
                        newBookData.coverImage =  Convert.convertImageUrlToUIImage(bookData.coverImage).pngData()
                    }else{
                        newBookData.coverImage =  Data()
                    }
                    newBookData.categoryStatus = bookData.categoryStatus ?? ""
                    newBookData.images = Convert.convertImageUrlListToUIImageList(bookData.images!).encode()
                    newBookData.date = UtilDate().stringToDateTime(dateString: bookData.date!)
                    newBookData.pageCount = Int16(0)
                    try context.save()
                }
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
  private  func deleteAllBookDatas(context:NSManagedObjectContext) {
      if(!getAllData().isEmpty){
          getAllData().forEach(context.delete)
          do {
              try context.save()
          } catch {
              let nsError = error as NSError
              fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
          }
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
        try await FirebaseServise().deleteUpLoadImage()
        let deleteDocumentItems  = try await FirebaseServise().db.collection("users").document(FirebaseServise().getUserId()).collection("books").getDocuments().documents
        try await withThrowingTaskGroup(of: Void.self) { group in
            for document in deleteDocumentItems{
                try await document.reference.delete()
            }
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
