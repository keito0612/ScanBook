//
//  TextFieldView .swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI

struct TextFieldView: View {
    let lavel:String
    @Binding var text: String
    @Binding var errorValidation: Bool
    let errorText:String
    let hintText:String
    let submit : () -> Void
    var body: some View {
        
        VStack{
            Text(lavel)
                .bold()
                .font(.system(size: Bounds.height * 0.02))
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onSubmit {
                    submit()
                }
            TextField("", text: $text, prompt: Text(hintText).foregroundColor(Color.gray.opacity(8.0)))
                .frame(height: Bounds.height * 0.03)
            .foregroundColor(Color.white)
            .font(.system(size: Bounds.width * 0.04))
            .accentColor(Color.white)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: Bounds.width * 0.1)
                    .stroke( errorValidation ? Color.red : Color.white, lineWidth: 3)
            )
            .frame(height : Bounds.height * 0.06)
            .padding(.horizontal)
            if(errorValidation){
                Text(errorText)
                    .font(.system(size: Bounds.width * 0.03))
                    .bold()
                    .foregroundColor(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    @State static var text = ""
    @State static var errorValidation: Bool = true
    static var lavel = "タイトル名"
    static var hintText = "リゼロ"
    static var errorText = "※タイトルが入力されていません。"
    static var previews: some View {
        TextFieldView(lavel: lavel,text: $text,errorValidation: $errorValidation,errorText: errorText,   hintText: hintText, submit:{})
    }
}
