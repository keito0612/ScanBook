//
//  LoginPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/19.
//

import SwiftUI
import CoreData

struct LoginPage: View {
    @EnvironmentObject var router:NavigationSettingRouter
    @StateObject var loginViewModel:LoginViewModel = LoginViewModel()
    @Environment(\.managedObjectContext)private var context
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack {
                    Group{
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            IPhoneLoginBodyView(loginViewModel: loginViewModel,context:context)
                        } else if UIDevice.current.userInterfaceIdiom == .pad {
                            IPadLoginBodyView(loginViewModel: loginViewModel,context:context)
                        }
                    }.padding(.horizontal,28).padding(.vertical, 44)
                    PasswordResetButton(onTap: {
                        router.path.append(.resetPassword)
                    })
                }
            }.loadingView(message: "読み込み中", scaleEffect: 3, isPresented:$loginViewModel.isLoading )
            if(loginViewModel.showAlert){
                CustomAlertView(alertType: loginViewModel.alertType, title: loginViewModel.alertTitle, message: loginViewModel.alertMessage, isShow: $loginViewModel.showAlert,onSubmit:{
                    if(loginViewModel.alertType == .success){
                        router.path.removeLast()
                    }
                })
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
    let context:NSManagedObjectContext
    var body: some View{
        VStack(spacing: 84){
            FormTextFieldView(lavel: "メールアドレス", text: $loginViewModel.emailText,errorValidation: loginViewModel.emailErrorValidetion,errorText: loginViewModel.emailErrorText)
            FormTextFieldView(lavel: "パスワード", text: $loginViewModel.passwordText, isPassword:true,passwordHidden:$loginViewModel.passwordHidden,errorValidation: loginViewModel.passwordErrorValidetion, errorText: loginViewModel.passwordErrorText)
            FormButtonView(name: "ログイン", onTap: {
                Task{
                    await loginViewModel.signIn(context: context)
                }
            }).padding(.top, 16)
        }
    }
}

struct IPadLoginBodyView :View{
    @ObservedObject var loginViewModel:LoginViewModel
    let context:NSManagedObjectContext
    var body: some View{
        VStack(spacing: 84){
            Spacer()
            FormTextFieldView(lavel: "メールアドレス", text: $loginViewModel.emailText,errorValidation: loginViewModel.emailErrorValidetion,errorText: loginViewModel.emailErrorText)
            FormTextFieldView(lavel: "パスワード", text: $loginViewModel.passwordText, isPassword:true,passwordHidden:$loginViewModel.passwordHidden,errorValidation: loginViewModel.passwordErrorValidetion, errorText: loginViewModel.passwordErrorText)
            FormButtonView(name: "ログイン", onTap: {
                Task{
                    await loginViewModel.signIn(context: context)
                }
            }).padding(.top, 16)
        }.padding(.horizontal, 260)
    }
}

struct PasswordResetButton:View{
    let onTap: () -> Void
    var body: some View{
        Button(
            action:onTap ,
            label:{
                Text("パスワードをお忘れの方はこちらへ").bold().foregroundStyle(.white)
            }
        )
    }
}


#Preview {
    NavigationStack{
        LoginPage().environmentObject(NavigationSettingRouter()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
