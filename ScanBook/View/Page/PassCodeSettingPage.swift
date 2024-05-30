//
//  PasscodeSettingPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/05/23.
//

import SwiftUI

struct PassCodeSettingPage: View {
    @StateObject var passCodeModel: PasscodeSettingModel = PasscodeSettingModel()
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack {
                    List{
                        Section() {
                            PassCodeLockItemButton(onTap: {
                                passCodeModel.isPassCodeLock.toggle()
                                if(passCodeModel.isPassCodeLock){
                                    
                                }else{
                                    
                                }
                            }, model: passCodeModel  ).buttonStyle(BorderlessButtonStyle())
                                .listRowSeparatorTint(.white)
                                .listRowBackground(Color(white: 0.2, opacity: 1.0))
                            
                            FaceIdItemButton(model: passCodeModel,onTap: {
                                passCodeModel.isFaceId.toggle()
                                if(passCodeModel.isFaceId){
                                    
                                }else{
                                    
                                }
                            }).buttonStyle(BorderlessButtonStyle()).listRowBackground(Color(white: 0.2, opacity: 1.0))
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
                  .customBackButton(onBack: {})
            }
        }
    }
}

struct PassCodeLockItemButton :View{
    let onTap: ()-> Void
    @ObservedObject var model: PasscodeSettingModel
    var body: some View{
        Button(action: onTap,label: {
            HStack{
                Text("パスワードロック").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity, alignment: .leading)
                Toggle("", isOn: $model.isPassCodeLock)
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
    PassCodeSettingPage()
}
