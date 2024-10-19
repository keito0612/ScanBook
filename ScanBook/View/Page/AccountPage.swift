//
//  AccountPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/19.
//

import SwiftUI

struct AccountPage: View {
    @EnvironmentObject var router:NavigationSettingRouter
    @StateObject var accountViewModel:AccountViewModel = AccountViewModel()
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack {
                List{
                    if(accountViewModel.isAuthenticated){
                        Group{
                            Section(header: Text("バックアップ").bold().foregroundStyle(Color.white)) {
                                BackUpItemView(onTap: {})
                            }
                            Section(header: Text("アカウント").bold().foregroundStyle(Color.white)) {
                                LogoutItemView(onTap: {
                                    AccountViewModel().signOut()
                                })
                                DeleteAccountItemView(onTap: {
                                    accountViewModel.alertTitle = "アカウントを削除しますか?"
                                    accountViewModel.alertMessage = "削除したアカウントは、戻りません。"
                                    accountViewModel.showAlert.toggle()
                                })
                            }
                        }
                    }else{
                        LoginItemView(onTap: {
                            router.path.append(.login)
                        })
                        SinUpItemView(onTap: {
                            router.path.append(.sinUp)
                        })
                    }
                }.listStyle(.insetGrouped)
                    .background(Color.black)
                    .scrollContentBackground(.hidden)
            }
            if(accountViewModel.showAlert){
                CustomAlertView(alertType: .warning, title:accountViewModel.alertTitle , message: accountViewModel.alertMessage,onCansel:{
                }, onDestructive:{
                    accountViewModel.alertTitle = "最終確認"
                    accountViewModel.alertMessage = "本当にアカウントを削除してもよろしいでしょうか?"
                    accountViewModel.showAlert2 = true
                } ,isShow: $accountViewModel.showAlert)
            }
            if(accountViewModel.showAlert2){
                CustomAlertView(alertType: .warning, title:accountViewModel.alertTitle , message: accountViewModel.alertMessage,onDestructive:{
                    
                }, isShow: $accountViewModel.showAlert2)
            }
        }.navigationBarTitle("アカウント", displayMode: .inline)
            .toolbarBackground(Color.black,for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
            .customBackButton(onBack: {
                router.path.removeLast()
            })    }
}


struct BackUpItemView:View {
    let onTap:() -> Void
    var body:some View{
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Text("バックアップ").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity,alignment: .leading)
            }
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
        
    }
}
struct DeleteAccountItemView:View {
    let onTap:() -> Void
    var body:some View{
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Text("アカウント削除").foregroundStyle(Color.red).bold().frame(maxWidth: .infinity,alignment: .leading)
            }
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
        
    }
}


struct LogoutItemView:View {
    let onTap:() -> Void
    var body:some View{
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Text("ログアウト").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity,alignment: .leading)
            }
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
        
    }
}


struct LoginItemView:View {
    let onTap:() -> Void
    var body:some View{
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Text("ログイン").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity,alignment: .leading)
            }
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
        
    }
}

struct SinUpItemView:View {
    let onTap:() -> Void
    var body:some View{
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Text("新規登録").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity,alignment: .leading)
            }
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
        
    }
}





#Preview {
    NavigationStack{
        AccountPage().environmentObject(NavigationSettingRouter()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
