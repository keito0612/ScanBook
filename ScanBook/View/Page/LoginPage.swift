//
//  LoginPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/19.
//

import SwiftUI

struct LoginPage: View {
    @StateObject var loginViewModel:LoginViewModel = LoginViewModel()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                Group{
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        IPhoneLoginBodyView(loginViewModel: loginViewModel)
                    } else if UIDevice.current.userInterfaceIdiom == .pad {
                        IPadLoginBodyView(loginViewModel: loginViewModel)
                    }
                }
            }.loadingView(message: "読み込み中", scaleEffect: 3, isPresented:$loginViewModel.isLoading )
            if(loginViewModel.showAlert){
                CustomAlertView(alertType: loginViewModel.alertType, title: loginViewModel.alertTitle, message: loginViewModel.alertMessage, isShow: $loginViewModel.showAlert)
            }
        }.navigationTitle("ログイン")
            .toolbarBackground(Color.black,for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
            .customBackButton(onBack: {
            })
    }
}

struct IPhoneLoginBodyView :View{
    @ObservedObject var loginViewModel:LoginViewModel
    var body: some View{
        VStack(spacing: 84){
            FormTextFieldView(lavel: "メールアドレス", text: $loginViewModel.emailText)
            FormTextFieldView(lavel: "パスワード", text: $loginViewModel.passwordText, isPassword:true,passwordHidden:$loginViewModel.passwordHidden)
            FormButtonView(name: "ログイン", onTap: {
                Task{
//                    await loginViewModel.sinUp()
                }
            }).padding(.top, 16)
            Spacer()
        } .padding(.horizontal,28).padding(.vertical, 44)
    }
}

struct IPadLoginBodyView :View{
    @ObservedObject var loginViewModel:LoginViewModel
    var body: some View{
        VStack(spacing: 84){
            Spacer()
            FormTextFieldView(lavel: "メールアドレス", text: $loginViewModel.emailText)
            FormTextFieldView(lavel: "パスワード", text: $loginViewModel.passwordText, isPassword:true,passwordHidden:$loginViewModel.passwordHidden)
            FormButtonView(name: "新規登録", onTap: {
                Task{
//                    await loginViewModel.sinUp()
                }
            }).padding(.top, 16)
            Spacer()
        }.padding(.horizontal, 260)
    }
}

struct SinUPTextButton:View{
    let onTap: () -> Void
    var body: some View{
        Button(
            action:onTap ,
            label:{
                Text("パスワード").bold().foregroundStyle(.white)
            }
        )
    }
}


#Preview {
    NavigationStack{
        LoginPage()
    }
}
