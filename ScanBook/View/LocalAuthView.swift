//
//  LocalAuthView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/05/30.
//

import SwiftUI
import LocalAuthentication

struct LocalAuthView: View {
    @State private var isUnlocked = false
    @State private var isShowAlert = false
    @State  var message = ""
    private var alertMessage = ""
    
    var body: some View {
        ZStack {
            VStack {
                if isUnlocked {
                    Text("Unlocked")
                } else {
                    Text("Locked")
                }
            }
            CustomAlertView(alertType: .error, title: "エラーが発生しました。" , message:message , isShow: $isShowAlert, onSubmit: {
            })
        }.onAppear{
            LocalAuthServise().auth(
                complation:{ value in
                isShowAlert = false
                self.isUnlocked = true
            }, failure:{ error in
                message = error
                isShowAlert = true
            })
        }
    }
}

#Preview {
    LocalAuthView()
}
