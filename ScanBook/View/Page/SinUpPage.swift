//
//  SinUpPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/18.
//

import SwiftUI

struct SinUpPage: View {
    @EnvironmentObject var router:NavigationSettingRouter
    @StateObject var sinUpViewModel:SinUpViewModel = SinUpViewModel()
    var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    Group{
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            IPhoneSinUPBodyView(sinUpViewModel: sinUpViewModel)
                        } else if UIDevice.current.userInterfaceIdiom == .pad {
                            IPadSinUpBodyView(sinUpViewModel: sinUpViewModel)
                        }
                    }
                }.loadingView(message: "アカウントを作成中", scaleEffect: 3, isPresented:$sinUpViewModel.isLoading )
                if(sinUpViewModel.showAlert){
                    CustomAlertView(alertType: sinUpViewModel.alertType, title: sinUpViewModel.alertTitle, message: sinUpViewModel.alertMessage, isShow: $sinUpViewModel.showAlert,onSubmit: {
                        router.path.remove(at: 1)
                    })
                }
            }.navigationTitle("新規登録")
            .toolbarBackground(Color.black,for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
            .customBackButton(onBack: {
                router.path.remove(at: 1)
            },isDismiss: false)
    }
}

struct IPhoneSinUPBodyView :View{
    @ObservedObject var sinUpViewModel:SinUpViewModel
    var body: some View{
        VStack(spacing: 84){
            FormTextFieldView(lavel: "メールアドレス", text: $sinUpViewModel.emailText,errorValidation: sinUpViewModel.emailErrorValidetion, errorText: sinUpViewModel.emailErrorText)
            FormTextFieldView(lavel: "パスワード", text: $sinUpViewModel.passwordText, isPassword:true,passwordHidden:$sinUpViewModel.passwordHidden,
                              errorValidation: sinUpViewModel.passwordErrorValidetion, errorText: sinUpViewModel.passwordErrorText
            )
            FormButtonView(name: "新規登録", onTap: {
                Task{
                    await sinUpViewModel.sinUp()
                }
            }).padding(.top, 16)
            Spacer()
        } .padding(.horizontal,28).padding(.vertical, 44)
    }
}

struct IPadSinUpBodyView :View{
    @ObservedObject var sinUpViewModel:SinUpViewModel
    var body: some View{
        VStack(spacing: 84){
            Spacer()
            FormTextFieldView(lavel: "メールアドレス", text: $sinUpViewModel.emailText, errorValidation: sinUpViewModel.emailErrorValidetion, errorText: sinUpViewModel.emailErrorText)
            FormTextFieldView(lavel: "パスワード", text: $sinUpViewModel.passwordText, isPassword:true,passwordHidden:$sinUpViewModel.passwordHidden,
                              errorValidation: sinUpViewModel.passwordErrorValidetion, errorText: sinUpViewModel.passwordErrorText
            )
            FormButtonView(name: "新規登録", onTap: {
                Task{
                    await sinUpViewModel.sinUp()
                }
            }).padding(.top, 16)
            Spacer()
        }.padding(.horizontal, 260)
    }
}


#Preview("iPhone 16") {
    NavigationStack{
        SinUpPage().environmentObject(NavigationSettingRouter())
    }
}

