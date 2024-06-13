//
//  PassCodeScreenView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/04.
//

import SwiftUI

struct PassCodeSettingScreenView: View {
    @EnvironmentObject var router:NavigationSettingRouter
    @EnvironmentObject var passCheck: PassCheck
    @State var count = 0
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("パスコードの入力")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                
                HStack{
                    //黒丸
                    ForEach(0..<4) { index in
                        if passCheck.firstCheck[index] == nil {
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
                    .foregroundColor(Color.pink)
                Spacer()
                
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
            .navigationTitle("入力")
            .navigationBarBackButtonHidden()
            .customBackButton(onBack: {
                passCheck.firstCheck = [nil, nil, nil, nil]
                passCheck.passText = "パスワードを忘れると復元できません\n忘れないようご注意ください"
            })
        }
    }
    
    private func inputText(number : String) {
        for (index, getText) in passCheck.firstCheck.enumerated() {
            if getText == nil {
                
                passCheck.firstCheck[index] = number
                if index == 3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1  ) {
                        router.path.append(.passCodeSettingScreen2)
                    }
                }
                break
            }
        }
    }
    private func daleteText(){
        var  inputTapIndex :Int? = nil
        for index in passCheck.firstCheck.indices {
            if(passCheck.firstCheck[index] != nil){
                inputTapIndex = index
            }
        }
        if(inputTapIndex != nil){
            passCheck.firstCheck[inputTapIndex!] = nil
        }
    }
}

#Preview {
    return PassCodeSettingScreenView().environmentObject(PassCheck())
        .environmentObject(NavigationSettingRouter())
}

