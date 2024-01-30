//
//  AddPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI

struct AddPage: View {
    @StateObject var  addModel: AddModel = AddModel()
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack{
                    TextFieldView(lavel: "タイトル", text: $addModel.titleText, errorValidation: $addModel.titleErrorValidation, errorText:addModel.titleErrorText , hintText: "本名、漫画名、レシート名", submit:{})
                    Divider().frame(height: 2).background(Color.white).padding()
                    DropDownView(value:$addModel.category , lavel: "カテゴリー", dropItemList: addModel.categoryItems, errorValidation: $addModel.categoryValidetion, errorText: addModel.errorCategoryText, onChange: {(value) in })
                    Divider().frame(height: 2).background(Color.white).padding()
                    BookCoverView(model: addModel)
                    Divider().frame(height: 2).background(Color.white).padding()
                    BookPageAdd(model: addModel)
                    Spacer()
                }.padding(.all, 10).navigationBarTitle("追加", displayMode: .inline)
                    .toolbarBackground(Color.black,for: .navigationBar)
                 .toolbarBackground(.visible, for: .navigationBar)
             .toolbarColorScheme(.dark)
            }
        }
    }
}

struct BookCoverView :View{
    @ObservedObject var model:AddModel
    var body: some View{
        VStack{
            Text("本 / 漫画の表紙")
                .bold()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Rectangle()
                .fill(Color.white)               // 図形の塗りつぶしに使うViewを指定
                .frame(width:150, height: 180).onTapGesture {
                    
                }
        }
    }
}

struct BookPageAdd :View{
    @ObservedObject var model:AddModel
    var body: some View{
        VStack{
            Text("ページの追加")
                .bold()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("現在のページ数").padding(.top).font(.system(size: 13)).foregroundColor(Color.white)
            Text(String(model.pageCount)).bold().font(.system(size: 30)).foregroundColor(Color.white)
            Button(action: {
             
            }) {
                Text("ページを追加する").bold().foregroundColor(Color.white)
            }.background(Color.white).padding()
            
        }
    }
}

struct AddPage_Previews: PreviewProvider {
    static var previews: some View {
        AddPage()
    }
}
