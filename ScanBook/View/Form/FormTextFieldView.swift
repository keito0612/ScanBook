//
//  FormTextFieldView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/10/15.
//

import SwiftUI

struct FormTextFieldView: View {
    let lavel:String
    @Binding var text: String
    let isPassword:Bool
    @Binding var passwordHidden:Bool
    var errorValidation: Bool
    let errorText:String
    let hintText:String
    
    init(lavel: String, text:Binding<String>, isPassword: Bool = false, passwordHidden: Binding<Bool> = .constant(false), errorValidation: Bool = false, errorText: String = "", hintText: String = "") {
        self.lavel = lavel
        self._text = text
        self.isPassword = isPassword
        self._passwordHidden = passwordHidden
        self.errorValidation = errorValidation
        self.errorText = errorText
        self.hintText = hintText
    }
    
    var body: some View {
        VStack{
            Text(lavel)
                .bold()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            if(isPassword){
                ZStack {
                    HStack{
                        if(passwordHidden){
                            SecureField("", text: self.$text)
                                .font(.system(size: 24))
                                .foregroundColor(Color.white)
                                .accentColor(Color.white)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke( errorValidation ? Color.red : Color.white, lineWidth: 3)
                                )
                        }else{
                            TextField("", text: $text, prompt: Text(hintText).foregroundColor(Color.gray.opacity(8.0)))
                                .font(.system(size: 24))
                                .foregroundColor(Color.white)
                                .accentColor(Color.white)
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke( errorValidation ? Color.red : Color.white, lineWidth: 3)
                                )
                        }
                    }
                    HStack {
                        Spacer()
                        Button(action: {passwordHidden.toggle() }) {
                            // アイコンそれぞれの名前を指定
                            Image(systemName: passwordHidden ? "eye.slash.fill": "eye.fill")
                            // アイコンそれぞれの色を指定
                                .foregroundColor((passwordHidden) ? Color.gray : Color.white)
                                
                            // 重ねて表示するための位置調整
                        }.frame(width: 44,height: 35).background(Color.black).padding(.trailing, 2)
                    }
                }
            }else{
                TextField("", text: $text, prompt: Text(hintText).foregroundColor(Color.gray.opacity(8.0)))
                    .font(.system(size: 24))
                    .foregroundColor(Color.white)
                    .accentColor(Color.white)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke( errorValidation ? Color.red : Color.white, lineWidth: 3)
                    )
            }
            if(errorValidation){
                Text(errorText)
                    .bold()
                    .foregroundColor(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var passwordHidden:Bool = true
    let lavel :String = "メールアドレス"
    let isPassword :Bool = true
    var errorValidation :Bool = true
    let hintText:String = ""
    let errorText:String = "※パスワードが入力されていません。"
    ZStack{
        Color.black
            .ignoresSafeArea()
        FormTextFieldView(lavel: lavel, text: $text, isPassword:isPassword, passwordHidden: $passwordHidden  ,errorValidation: errorValidation, errorText: errorText, hintText: hintText)
    }
}
