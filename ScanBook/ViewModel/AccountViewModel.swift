//
//  AccountViewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/19.
//

import Foundation

class AccountViewModel: ObservableObject{
    @Published var showAlert:Bool = false
    @Published var showAlert2:Bool = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isAuthenticated = false
    
    init(){
        FirebaseServise().addStateDidChangeListener(completion: { isAuthenticated  in
            self.isAuthenticated = isAuthenticated
        })
    }
    
    
    func signOut() {
        do{
            try FirebaseServise().signOut()
        }catch let error as NSError {
            print(error)
        }
    }
}
