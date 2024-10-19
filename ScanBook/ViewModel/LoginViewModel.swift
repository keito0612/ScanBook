//
//  LoginViewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/19.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class LoginViewModel:  ObservableObject {
    @Published var emailText:String = ""
    @Published var passwordText:String = ""
    @Published var passwordHidden:Bool = true
    @Published var isLoading:Bool = false
    @Published var alertType:AlertType = .success
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
   
    @MainActor
    func sinIn() async{
        isLoading = true
        do{
            try await FirebaseServise().signUp(email: emailText, password: passwordText)
            isLoading = false
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
}
