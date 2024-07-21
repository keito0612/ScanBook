//
//  PasscodeSettingPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/05/23.
//

import SwiftUI

struct PassCodeSettingPage: View {
    @StateObject var passCodeSettingModel: PasscodeSettingModel = PasscodeSettingModel()
    @EnvironmentObject var router:NavigationSettingRouter
    var body: some View {
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack {
                    List{
                        Section() {
                            PassCodeLockItemButton(
                                onTap: {
                                passCodeSettingModel.isPassCodeLock.toggle()
                                if(!passCodeSettingModel.isPassCodeLock){
                                    passCodeSettingModel.isFaceId = false
                                }else{
                                    router.path.append(.passCodeSettingScreen)
                                }
                            }, model: passCodeSettingModel  ).buttonStyle(BorderlessButtonStyle())
                                .listRowSeparatorTint(.white)
                                .listRowBackground(Color(white: 0.2, opacity: 1.0))
                            if(passCodeSettingModel.isPassCodeLock){
                                FaceIdItemButton(model: passCodeSettingModel,onTap: {
                                    passCodeSettingModel.isFaceId.toggle()
                                    if(passCodeSettingModel.isFaceId){
                                        LocalAuthServise().auth(
                                            complation: {_ in },
                                            failure: { error in
                                                passCodeSettingModel.isShowAlert = true
                                                passCodeSettingModel.alertMessage = error
                                                passCodeSettingModel.isFaceId = false
                                            })
                                    }
                                }).buttonStyle(BorderlessButtonStyle()).listRowBackground(Color(white: 0.2, opacity: 1.0))
                            }
                        }
                    }.listStyle(.automatic)
                        .listRowSeparatorTint(.white)
                        .background(Color.black)
                        .environment(\.defaultMinListRowHeight, 60)
                        .scrollContentBackground(.hidden)
                }.navigationBarTitle("パスコード設定", displayMode: .inline)
                    .toolbarBackground(Color.black,for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .customBackButton(onBack: {
                        router.path.removeLast()
                    })
                CustomAlertView(alertType: .error, title: "エラーが発生しました。", message:passCodeSettingModel.alertMessage , isShow: $passCodeSettingModel.isShowAlert)
            }.onAppear{
                passCodeSettingModel.isFaceId = UserDefaults.standard.bool(forKey: "isFaceId")
                passCodeSettingModel.isPassCodeLock = UserDefaults.standard.bool(forKey: "isPassCodeLock")
            }
        }
    }

struct PassCodeLockItemButton :View{
    let onTap: ()-> Void
    @ObservedObject var model: PasscodeSettingModel
    var body: some View{
        Button(action: onTap,label: {
            HStack{
                Text("パスコードロック").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity, alignment: .leading)
                Toggle("", isOn:model.$isPassCodeLock )
            }
        })
    }
}

struct FaceIdItemButton:View{
    @ObservedObject var model: PasscodeSettingModel
    let onTap: ()-> Void
    var body: some View{
        Button(action: onTap,label: {
            HStack{
                Text("faceID").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity, alignment: .leading)
                Toggle("", isOn: $model.isFaceId)
            }
        })
    }
}



#Preview {
    return PassCodeSettingPage().environmentObject(NavigationSettingRouter())
}
