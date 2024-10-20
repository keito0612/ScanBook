//
//  PasswordViewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class ResetPasswordViewModel :ObservableObject{
    @Published var emailText:String = ""
    @Published var emailErrorText:String = ""
    @Published var emailErrorValidetion:Bool = false
    @Published var isLoading:Bool = false
    @Published var alertType:AlertType = .success
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    
    
    @MainActor
    func resetPassword() async{
        if(isValidetion()){
            return
        }
        isLoading = true
        do{
            try await  FirebaseServise().passwordReset(email: emailText)
            isLoading = false
            alertType = .success
            alertTitle = "パスワード再設定用のメールを送りました。"
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
    
    private func isValidetion() -> Bool{
        var valide:Bool = false
        emailErrorText = ""
        emailErrorValidetion = false
        
        if(emailText.isEmpty){
            emailErrorValidetion = true
            emailErrorText = "※パスワードを入力してください。"
            valide = true
            return valide
        }
        return valide
    }
}
