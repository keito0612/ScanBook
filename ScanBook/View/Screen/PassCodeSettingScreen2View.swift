//
//  PassCodeSettingScreen2View.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/08.
//

import SwiftUI

struct PassCodeSettingScreen2View: View{
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var passCheck: PassCheck
    @EnvironmentObject var router:NavigationSettingRouter
    @AppStorage("isPassCodeLock") var isPassCodeLock:Bool = false
    
    @State var isShowAlert = false
    @State var passCode = ""
    
    var body: some View{
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing:0){
                Text("パスコードの再入力")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding(.top,70)
                
                //黒丸or白丸
                HStack{
                    ForEach(0..<4) { index in
                        if passCheck.secondCheck[index] == nil {
                            Image(systemName: "circle")
                                .foregroundStyle(.white)
                                .padding()
                        }else {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(.white)
                                .padding()
                        }
                    }
                }
                
                //注意事項
                Text("\(passCheck.passText)")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.clear)
                    .padding(.bottom, 24)
                //入力ボタン
                HStack{
                    ForEach(1..<4){ i in
                        Button{
                            inputText(number: String(i))
                        }label:{
                            Text("\(i)")
                                .font(.title)
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color(.white))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.white), lineWidth: 3.0)
                                )
                        }.padding(.all, 4)
                    }
                }
                HStack{
                    ForEach(4..<7){ i in
                        Button{
                            inputText(number: String(i))
                        }label:{
                            Text("\(i)")
                                .font(.title)
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color(.white))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.white), lineWidth: 3.0)
                                )
                        }.padding(.all, 4)
                    }
                }
                HStack{
                    ForEach(7..<10){ i in
                        Button{
                            inputText(number: String(i))
                        }label:{
                            Text("\(i)")
                                .font(.title)
                                .frame(width: 90, height: 90)
                                .foregroundColor(Color(.white))
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.white), lineWidth: 3.0)
                                )
                        }.padding(.all, 4)
                    }
                }
                HStack {
                    Button{
                        inputText(number: "0")
                    }label:{
                        Text("0")
                            .font(.title)
                            .frame(width: 90, height: 90)
                            .foregroundColor(Color(.white))
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.white), lineWidth: 3.0)
                            )
                    }.padding(.all,4).padding(.leading,100)
                    Button{
                        daleteText()
                    }label:{
                        Image(systemName: "delete.left")
                            .font(.system(size: 40, weight: .medium))
                            .frame(width: 90, height: 90)
                            .foregroundColor(Color(.white))
                        
                    }.padding(.top, 4)
                }
                Spacer()
            }
            .navigationTitle("確認入力")
            .navigationBarBackButtonHidden()
            .customBackButton {
                passCheck.firstCheck = [nil, nil, nil, nil]
            }
            .alert(Text("FaceIdを使いますか？"), isPresented: $isShowAlert){
                Button("はい"){
                    UserDefaults.standard.set(true, forKey: "isFaceId")
                    router.path.removeLast(router.path.count)
                    passCheck.firstCheck = [nil, nil, nil, nil]
                    passCheck.secondCheck = [nil, nil, nil, nil]
                }
                Button("いいえ"){
                    UserDefaults.standard.set(false, forKey: "isFaceId")
                    router.path.removeLast(router.path.count)
                    passCheck.firstCheck = [nil, nil, nil, nil]
                    passCheck.secondCheck = [nil, nil, nil, nil]
                }
            }
        }
    }
    
    private func daleteText(){
        var  inputTapIndex :Int? = nil
        for index in passCheck.secondCheck.indices {
            if(passCheck.secondCheck[index] != nil){
               inputTapIndex = index
            }
        }
        if(inputTapIndex != nil){
            passCheck.secondCheck[inputTapIndex!] = nil
        }
    }
    //ボタンが押された時の関数
    private func inputText(number : String) {
        for (index, getText) in passCheck.secondCheck.enumerated() {
            //nilかチェック　→ 入力済みならスキップ
            //入力したらfor文を抜け出す
            if getText == nil {
                
                passCheck.secondCheck[index] = number
                //全入力された時
                if index == 3 {
                    if passCheck.firstCheck == passCheck.secondCheck {
                        //同じなら保存, alert（faceID)、
                        for i in 0...3 {
                            passCode = passCode + (passCheck.firstCheck[i] ?? "")

                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            UserDefaults.standard.set(true, forKey: "SetPass")
                            UserDefaults.standard.set(passCode, forKey: "password")
                            isPassCodeLock = true
                            isShowAlert = true
                        }
                        
                    }else{
                        //違うなら初期化して１つ前へ
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            passCheck.passText = "パスワードが1回目と異なります\nもう一度行ってください"
                            passCheck.firstCheck = [nil, nil, nil, nil]
                            passCheck.secondCheck = [nil, nil, nil, nil]
                                router.path.removeLast()
                        }
                    }
                }
                break
            }
            
        }
        
    }
}
#Preview {
   return  PassCodeSettingScreen2View().environmentObject(PassCheck())
       .environmentObject(NavigationSettingRouter())
}
