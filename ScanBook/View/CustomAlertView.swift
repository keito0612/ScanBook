//
//  CustomAlertView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/03/16.
//

import SwiftUI

enum AlertType{
    case loading
    case error
    case warning
    case confirmation
    case success
}

struct CustomAlertView: View {
    let alertType: AlertType
    let title : String
    let message :String
    let cancelButtonLabel :String
    let onCansel:() -> Void
    let destructiveLavel : String
    let onDestructive:() -> Void
    @Binding  var isShow : Bool
    let onSubmit: () -> Void
    init(alertType: AlertType, title: String, message: String, cancelButtonLabel: String = "いいえ" , onCansel: @escaping () -> Void = {}, destructiveLavel: String = "はい", onDestructive: @escaping () -> Void = {}, isShow:Binding<Bool>, onSubmit: @escaping () -> Void) {
        self.alertType = alertType
        self.title = title
        self.message = message
        self.cancelButtonLabel = cancelButtonLabel
        self.onCansel = onCansel
        self.destructiveLavel = destructiveLavel
        self.onDestructive = onDestructive
        self._isShow = isShow
        self.onSubmit = onSubmit
    }
    var body: some View {
        ZStack {
            // 画面全体を覆う黒い背景
            if(isShow){
                Color.black
                    .opacity(0.5)
                VStack{
                    
                    if(alertType == .error){
                        Image(systemName: "xmark.app").foregroundColor(.red).font(.system(size: 35)).padding(.vertical)
                    }else if(alertType == .success){
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green).font(.system(size: 35)).padding(.vertical)
                    }else if(alertType == .warning){
                        Image(systemName: "exclamationmark.triangle").foregroundColor(.yellow).font(.system(size: 35)).padding(.vertical)
                    }
                    
                    Text(title).foregroundStyle(alertType == .success ? .black : .red ).bold().padding(.horizontal)
                    
                    Text(message).foregroundStyle(alertType == .success ? .black : .red  ).multilineTextAlignment(.center).padding(.top, 2).padding(.horizontal)
            
                    if(alertType == .confirmation || alertType == .warning){
                        HStack{
                            Button(action: {
                                onCansel()
                                isShow.toggle()
                            }) {
                                 
                                HStack{
                                    Spacer()
                                    Text(cancelButtonLabel).bold().font(.system(size: 20))
                                    Spacer()
                                }
                            }
                            Divider()
                            Button(action: {
                                onDestructive()
                                isShow.toggle()
                            }) {
                                HStack{
                                    Spacer()
                                    Text(destructiveLavel ).bold().font(.system(size: 20)).foregroundStyle( alertType == .warning ? Color.red : Color.blue )
                                    Spacer()
                                }.frame(width: 139)
                            }
                        }.overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.gray.opacity(0.5)), alignment: .top).frame(width: 300, height: 60)
                        
                    }else{
                        Button(action: {
                            isShow.toggle()
                            onSubmit()
                        },label: {
                            VStack{
                                Spacer()
                                Text("OK").font(.system(size: 20))
                                Spacer()
                            }.frame(width: 300)
                        }).overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.gray.opacity(0.5)), alignment: .top).frame(width: 300, height: 60)
                    }
                    
                }.frame(width: 300).frame(minHeight: 150)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    let alertType :AlertType = .success
    let title :String  = "削除しますか?"
    let message : String = "本当によろしいでしょうか?"
    @State var isShowDialog =  true
    return CustomAlertView(alertType: alertType, title: title,message: message,cancelButtonLabel: "いいえ", onCansel: {},destructiveLavel: "はい",isShow: $isShowDialog,onSubmit: {})
}
