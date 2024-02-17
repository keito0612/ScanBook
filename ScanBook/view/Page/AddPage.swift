//
//  AddPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI

struct AddPage: View {
    @StateObject var  addModel: AddModel = AddModel()
    @Environment(\.managedObjectContext)private var context
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                ScrollView {
                    VStack{
                        TextFieldView(lavel: "タイトル", text: $addModel.titleText, errorValidation: $addModel.titleErrorValidation, errorText:addModel.titleErrorText , hintText: "本名、漫画名、レシート名", submit:{})
                        Divider().frame(height: 2).background(Color.white).padding()
                        DropDownView(value:$addModel.category , lavel: "カテゴリー", dropItemList: addModel.categoryItems, errorValidation: $addModel.categoryValidetion, errorText: addModel.errorCategoryText, onChange: {(value) in
                            if(value == "漫画"){
                                addModel.categoryStatus = 0
                            }else if(value == "小説"){
                                addModel.categoryStatus = 1
                            }else{
                                addModel.categoryStatus = 2
                            }
                        })
                        Divider().frame(height: 2).background(Color.white).padding()
                        if(addModel.category != "書類"){                        BookCoverView(model: addModel)
                            Divider().frame(height: 2).background(Color.white).padding()
                        }
                            BookPageAdd(model: addModel)
                            Divider().frame(height: 2).background(Color.white).padding()
                        AddButton(model: addModel)
                    }.padding(.all, 10).navigationBarTitle("追加", displayMode: .inline)
                        .toolbarBackground(Color.black,for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarColorScheme(.dark)
                        .customBackButton()
                }
            }.sheet(isPresented: $addModel.showingScan) {
                ScannerView(scannedImages: $addModel.imageArray, scannedImage: $addModel.bookCovarImage, multiCapture: true, isScanning: $addModel.showingScan,  completion: {
                        addModel.pageCount =  addModel.imageArray.count
                })
            }
            .sheet(isPresented:$addModel.showingCovarImage ){
                ScannerView(scannedImages: $addModel.imageArray, scannedImage: $addModel.bookCovarImage, multiCapture: false, isScanning: $addModel.showingCovarImage,  completion: {
                })
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
            if(model.bookCovarImage.size == CGSize.zero){
                Rectangle()
                    .fill(Color.white)
                    .frame(width:130, height: 130).onTapGesture {
                        model.showingCovarImage.toggle()
                    }
                    .padding(.vertical)
            } else{
                Image(uiImage: model.bookCovarImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 130, height: 130).onTapGesture {
                    model.showingCovarImage.toggle()
                }
                    .padding(.vertical)
            }
        }
    }
}

struct BookPageAdd :View{
    @ObservedObject var model:AddModel
    var body: some View{
        VStack{
            Text( model.category == "書類" ?  "書類の追加"  : "ページの追加")
                .bold()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(model.category == "書類" ? "現在の枚数": "現在のページ数").padding(.top).font(.system(size: 13)).foregroundColor(Color.white)
            Text(String(model.pageCount)).bold().font(.system(size: 40)).foregroundColor(Color.white)
            Button(action: {
                model.showingScan.toggle()
            }) {
                Text(model.category == "書類" ? "書類を追加する": "ページを追加する").bold().foregroundColor(Color.white).frame(height: 60).frame(maxWidth: .infinity).background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 4)
                    ).padding(.horizontal)
            }
            
            Button(action: {
                
            }) {
                Text("確認").bold().foregroundColor(Color.white).frame(height: 60).frame(maxWidth: .infinity).background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 4)
                    ).padding()
            }
            if(model.pageErrorValidation){
                Text(model.pageErrorText)
                    .font(.system(size: 13))
                    .bold()
                    .foregroundColor(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
        }
    }
}

struct AddButton:View{
    @ObservedObject var model:AddModel
    var body: some View{
        Button(action: {
            if(isValidetion()){
                return
            }
            
        }) {
            Text("追加").bold().foregroundColor(Color.white).frame(height: 60).frame(maxWidth: .infinity).background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: 4)
                ).padding(.horizontal, 80)
        }
    }
    
    func isValidetion() -> Bool{
        var valide:Bool = false
        model.titleErrorValidation = false
        model.categoryValidetion = false
        model.pageErrorValidation = false
        //タイトル
        if(model.titleText.isEmpty){
            model.titleErrorValidation = true
            valide = true
            return valide
        }
        //カテゴリー
        if(model.categoryStatus == nil){
            model.categoryValidetion = true
            valide = true
            return valide
        }
        if(model.pageCount == 0){
            model.pageErrorValidation = true
        }else{
            
        }
        return valide
    }
}


struct AddPage_Previews: PreviewProvider {
    static var previews: some View {
        AddPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
