//
//  SettingPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/31.
//


import SwiftUI

struct SettingPage: View {
    @EnvironmentObject var router:NavigationSettingRouter
    @StateObject var settingModel : SettingModel = SettingModel()
    @FetchRequest(entity:BookData.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \BookData.date, ascending: false)],
           animation: .default)
    private var bookDatas: FetchedResults<BookData>
    @Environment(\.managedObjectContext)private var context
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack {
                List{
                    Section(header: Text("設定").bold().foregroundStyle(Color.white)) {
                        
                        PassCodeItemView(
                            onTap: {
                                router.path.append(.passCodeSetting)
                            })
                        AccountItemView(onTap: {
                            router.path.append(.account)
                        })
                        ICloudItemView(onTap: {
                            router.path.append(.iCloudSetting)
                        })
                        AllDeleteItemView(onTap: {
                            settingModel.alertTitle = "すべてのデータを削除しますか?"
                            settingModel.alertMessage = "削除したデータは復元できません。 （設定類のデータは削除されません）"
                            settingModel.showAlert.toggle()
                        })
                    }
                    
                    Section(header: Text("利用規約・プライバシーポリシー").bold().foregroundStyle(Color.white)) {
                        PrivacyPolicyView()
                    }
                    Section(header: Text("お問い合わせ").bold().foregroundStyle(Color.white)) {
                        InquiryItemView()
                    }
                }.listStyle(.insetGrouped)
                    .background(Color.black)
                    .scrollContentBackground(.hidden)
            }
            if(settingModel.showAlert){
                CustomAlertView(alertType: .warning, title:settingModel.alertTitle , message: settingModel.alertMessage,onCansel:{
                   
                }, onDestructive:{
                    settingModel.alertTitle = "最終確認"
                    settingModel.alertMessage = "本当にすべてのデータを削除してもよろしいでしょうか?"
                    settingModel.showAlert2 = true
                } ,isShow: $settingModel.showAlert)
            }
            if(settingModel.showAlert2){
                CustomAlertView(alertType: .warning, title:settingModel.alertTitle , message: settingModel.alertMessage,onDestructive:{
                    settingModel.deleteAllBookDatas(bookDatas:bookDatas,context: context)
                }, isShow: $settingModel.showAlert2)
            }
            if(settingModel.showAlert3){
                CustomAlertView(alertType: .success, title:settingModel.alertTitle , message: settingModel.alertMessage,onDestructive:{
                }, isShow: $settingModel.showAlert3)
            }
        }.navigationTitle("設定").toolbarBackground(Color.black,for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark)
    }
}

struct PassCodeItemView:View {
    let onTap:() -> Void
    var body:some View{
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Text("パスコード").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity,alignment: .leading)
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
        
    }
}

struct ICloudItemView:View {
    let onTap:() -> Void
    var body: some View {
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Text("iCloud").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity,alignment: .leading)
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
        
    }
}

struct AccountItemView:View {
    let onTap:() -> Void
    var body: some View {
        Button(action: {
            onTap()
        }, label: {
            HStack {
                Text("アカウント").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity,alignment: .leading)
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
        
    }
}

struct AllDeleteItemView:View {
    let onTap:() -> Void
    var body: some View {
        Button(action: {
            onTap()
        }, label: {
            Text("すべてのデータを削除").foregroundStyle(Color.red).bold().frame(maxWidth: .infinity,alignment: .leading)
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
        
    }
}

struct PrivacyPolicyView:View{
    @Environment(\.openURL) var openURL
    var body: some View{
        Button(action: {
            openURL(URL(string: "https://keito0612.github.io/scanbook_privacypolicy/")!)
        }, label: {
            Text("利用規約・プライバシーポリシー").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity,alignment: .leading)
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
    }
}

struct InquiryItemView:View{
    @Environment(\.openURL) var openURL
    var body: some View{
        Button(action: {
            openURL(URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeTUWSuCRijLPUwLSLRq-0WAb2ztJ0H5SN-cyzFrn6HfEjhqg/viewform")!)
        }, label: {
            Text("お問い合わせ").foregroundStyle(Color.white).bold().frame(maxWidth: .infinity,alignment: .leading)
        })
        .listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
    }
}



struct SettingPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingPage().environmentObject(NavigationSettingRouter()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
