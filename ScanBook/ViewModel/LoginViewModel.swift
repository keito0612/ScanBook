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
}
