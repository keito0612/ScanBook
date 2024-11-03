//
//  LoginViewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/19.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import CoreData

class LoginViewModel:  ObservableObject {
    @Published var emailText:String = ""
    @Published var emailErrorText:String = ""
    @Published var emailErrorValidetion:Bool = false
    @Published var passwordText:String = ""
    @Published var passwordErrorText:String = ""
    @Published var passwordErrorValidetion:Bool = false
    @Published var passwordHidden:Bool = true
    @Published var isLoading:Bool = false
    @Published var alertType:AlertType = .success
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
   
    @MainActor
    func signIn(context :NSManagedObjectContext) async{
        if(isValidetion()){
            return
        }
        isLoading = true
        do{
           let userId = try await FirebaseServise().signIn(email: emailText, password: passwordText)
            if(userId != ""){
                await getBackUpData(context: context)
                isLoading = false
                alertType = .success
                alertTitle = "ログインが完了しました。"
                showAlert = true
            }else{
                isLoading = false
                alertType = .error
                alertTitle = "ログインをする事が出来ませんでした。"
                alertMessage = "もう一度ログインをお願いします。"
                showAlert = true
            }
        }catch{
            isLoading = false
            let authErrorCode = AuthErrorCode(rawValue: error._code)
            let fireStoreError = FirestoreErrorCode.Code(rawValue: error._code)
            if(authErrorCode != nil){
                alertTitle = FirebaseErrorHandler.authErrorToString(error: authErrorCode!)
                alertMessage = FirebaseErrorHandler.authErrorMessageToString(error: authErrorCode!)
            }else if(fireStoreError != nil){
                alertTitle = FirebaseErrorHandler.FireStoreErrorToString(error: fireStoreError!)
                alertMessage = FirebaseErrorHandler.FireStoreErrorMessageToString(error: fireStoreError!)
            }
            alertType = .error
            showAlert = true
        }
    }
    
    private func isValidetion() -> Bool{
        var valide:Bool = false
        emailErrorText = ""
        passwordErrorText = ""
        emailErrorValidetion = false
        passwordErrorValidetion = false
        
        if(emailText.isEmpty){
            emailErrorValidetion = true
            emailErrorText = "※メールアドレスを入力してください。"
            valide = true
            return valide
        }
        if(passwordText.isEmpty){
            passwordErrorValidetion = true
            passwordErrorText = "※パスワードを入力してください。"
            valide = true
            return valide
        }
        return valide
    }
    
    private func getBackUpData(context :NSManagedObjectContext) async {
        var firestoreBookDataList: Array<FirestoreBookData> = []
        do{
            let documents = try await FirebaseServise().db.collection("users").document(FirebaseServise().getUserId()).collection("books").getDocuments().documents
            firestoreBookDataList =  documents.compactMap { try? $0.data(as: FirestoreBookData.self)}
            addBookData(firestoreBookDataList: firestoreBookDataList, context: context)
        }catch{
            print("エラーが発生しました。")
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
                    newBookData.categoryStatus = Int64(bookData.categoryStatus!)
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
}
