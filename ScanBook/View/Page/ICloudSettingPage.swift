//
//  ICloudSetingPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/20.
//

import SwiftUI

struct ICloudSettingPage: View {
    @StateObject var iCloudSettingModel: ICloudSettingModel = ICloudSettingModel()
    @EnvironmentObject var router:NavigationSettingRouter
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack {
                List{
                    Section() {
                        ICloudItemButton(onTap: {
                            iCloudSettingModel.iCloud.toggle()
                            if(iCloudSettingModel.iCloud){
                                CheckIcloudServise.checkICloudAvailability(failure: { error in
                                    iCloudSettingModel.alertMessage = error
                                    iCloudSettingModel.isShowAlert = true
                                    iCloudSettingModel.iCloud = false
                                })
                            }
                        }, model: iCloudSettingModel).buttonStyle(BorderlessButtonStyle())
                            .listRowSeparatorTint(.white)
                            .listRowBackground(Color(white: 0.2, opacity: 1.0))
                    }
                }.listStyle(.automatic)
                    .listRowSeparatorTint(.white)
                    .background(Color.black)
                    .environment(\.defaultMinListRowHeight, 60)
                    .scrollContentBackground(.hidden)
                
            }.navigationBarTitle("iCloud設定", displayMode: .inline)
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
                .customBackButton(onBack: {
                    router.path.removeLast()
                })
            CustomAlertView(alertType: .error, title: "エラーが発生しました。", message:iCloudSettingModel.alertMessage , isShow: $iCloudSettingModel.isShowAlert)
        }.onAppear{
        }
    }
}


struct ICloudItemButton :View{
    let onTap: ()-> Void
    @ObservedObject var model: ICloudSettingModel
    var body: some View{
        Button(action: onTap,label: {
            HStack{
                Text("Icloud").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity, alignment: .leading)
                Toggle("", isOn: $model.iCloud)
            }
        })
    }
}




#Preview {
    return ICloudSettingPage().environmentObject(NavigationSettingRouter())
}
