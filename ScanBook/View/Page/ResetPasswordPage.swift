//
//  ResetPasswordPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/20.
//

import SwiftUI

struct ResetPasswordPage: View {
    @EnvironmentObject var router:NavigationSettingRouter
    @StateObject var resetPasswordViewModel:ResetPasswordViewModel = ResetPasswordViewModel()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing:0){
                FormTextFieldView(lavel: "メールアドレス", text: $resetPasswordViewModel.emailText, isPassword:false,errorValidation: resetPasswordViewModel.emailErrorValidetion, errorText: resetPasswordViewModel.emailErrorText)
                FormButtonView(name: "パスワード再設定", onTap: {
                    Task{
                        await resetPasswordViewModel.resetPassword()
                    }
                }).padding(.top, 32)
                Spacer()
            }.padding(.horizontal, 36).padding(.top, 24).loadingView(message: "読み込み中", scaleEffect: 3, isPresented:$resetPasswordViewModel.isLoading )
            if(resetPasswordViewModel.showAlert){
                CustomAlertView(alertType: resetPasswordViewModel.alertType, title: resetPasswordViewModel.alertTitle, message:resetPasswordViewModel.alertMessage, isShow: $resetPasswordViewModel.showAlert,onSubmit:{
                    if(resetPasswordViewModel.alertType == .success){
                        router.path.removeLast()
                    }
                })
            }
        }.navigationBarTitle("パスワード再設定" , displayMode: .inline)
            .toolbarBackground(Color.black,for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
            .customBackButton(onBack: {
            })
    }
}

#Preview {
    NavigationStack{
        ResetPasswordPage().environmentObject(NavigationSettingRouter())
    }
}
