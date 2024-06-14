//
//  PassCodeLockScreenView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/06.
//

import SwiftUI

struct PassCodeLockScreenView: View {
    
    @State var passCheck: [String?] = [nil, nil, nil, nil]

    @State var isShow = false
    let persistenceController = PersistenceController.shared
    let answer = UserDefaults.standard.string(forKey: "password")

    @AppStorage("isFaceId") var isFaceId:Bool = UserDefaults.standard.bool(forKey: "password")
    
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("パスコードの入力")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                HStack{
                    ForEach(0..<4) { index in
                        if passCheck[index] == nil {
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
                                        .stroke(Color(.white), lineWidth:3.0)
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
                .onAppear{
                    if isFaceId {
                        LocalAuthServise().auth(complation: {_ in
                            passCheck = ["a", "a", "a", "a"]
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                withAnimation{
                                    isShow.toggle()
                                }
                            }
                        })
                    }
                }
            }
            
            if isShow {
                ContentView()
                    .environmentObject(PassCheck())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .transition(.opacity)
            }
            
        }
    }
    
    private func inputText(number : String) {
        var checkAnswer = ""
        
        for (index, getText) in passCheck.enumerated() {
            if getText == nil {
                
                passCheck[index] = number
                if index == 3 {
                    for i in 0...3 {
                        
                        checkAnswer = checkAnswer + (passCheck[i] ?? "")
                    }
                    if checkAnswer == answer {
                        //一致
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                            withAnimation{
                                isShow.toggle()
                            }
                        }
                        
                    }else{
                        //初期化
                        passCheck = [nil, nil, nil, nil]
                    }
                }
                
                break
            }
        }
    }
    
    private func daleteText(){
        var  inputTapIndex :Int? = nil
        for index in passCheck.indices {
            if(passCheck[index] != nil){
               inputTapIndex = index
            }
        }
        if(inputTapIndex != nil){
            passCheck[inputTapIndex!] = nil
        }
    }
}
#Preview {
    PassCodeLockScreenView()
}
