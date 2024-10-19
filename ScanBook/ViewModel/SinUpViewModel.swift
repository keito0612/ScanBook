//
//  SinUpViewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SinUpViewModel:  ObservableObject {
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
    func sinUp() async{
        if(isValidetion()){
            return
        }
        isLoading = true
        do{
            try await FirebaseServise().signUp(email: emailText, password: passwordText)
            isLoading = false
            alertTitle = "新規登録が完了しました。"
            alertType = .success
            showAlert = true
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
    public func isValidetion() -> Bool{
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
        if(passwordText.count <= 8){
            passwordErrorValidetion = true
            passwordErrorText = "※パスワードは８文字以上でお願いします。"
            valide = true
            return valide
        }
        if(passwordText.count > 32){
            passwordErrorValidetion = true
            passwordText = "※パスワードは32文字以下でお願いします。"
            valide = true
            return valide
        }
        return valide
    }
}
