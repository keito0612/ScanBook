//
//  AddPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI

struct AddPage: View {
    init(isPresented: Binding<Bool>, bookData: BookData?) {
        _isPresented = isPresented
        self.bookData = bookData
        _addModel = StateObject( wrappedValue: AddModel(bookData:bookData))
    }
    @Binding var isPresented :Bool
    let bookData: BookData?
    @StateObject var addModel: AddModel
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
                        if(addModel.category != "書類"){                        
                            BookCoverView(model: addModel)
                            Divider().frame(height: 2).background(Color.white).padding()
                        }
                        BookPageAdd(model: addModel)
                        Divider().frame(height: 2).background(Color.white).padding()
                        if(bookData == nil ){
                            AddButton(model: addModel, isPresented: $isPresented)
                        }else{
                            EditButton(model: addModel , isPresented: $isPresented)
                        }
                    }.padding(.all, 10).navigationBarTitle(bookData == nil ? "追加": "編集" , displayMode: .inline)
                        .navigationDestination(isPresented: $addModel.isPresented ) {
                            PreviewPage(images: addModel.imageArray)
                        }
                        .toolbarBackground(Color.black,for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarColorScheme(.dark)
                        .customBackButton(onBack: {})
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
                        .scaledToFit()
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
                    if(model.pageCount != 0){
                        model.isPresented = true
                    }else{
                        model.pageErrorValidation = true
                    }
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
    @Binding var isPresented :Bool
    @Environment(\.managedObjectContext)private var context
    var body: some View{
        Button(action: {
            if(model.isValidetion()){
                return
            }
            model.add(context: context)
            isPresented.toggle()
        }) {
            Text("追加").bold().foregroundColor(Color.white).frame(height: 60).frame(maxWidth: .infinity).background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: 4)
                ).padding(.horizontal, 80)
        }
    }
}

struct EditButton:View{
    @ObservedObject var model:AddModel
    @Binding var isPresented :Bool
    @Environment(\.managedObjectContext)private var context
    var body: some View{
        Button(action: {
            if(model.isValidetion()){
                return
            }
            model.edit(context: context)
            isPresented.toggle()
        }) {
            Text("編集").bold().foregroundColor(Color.white).frame(height: 60).frame(maxWidth: .infinity).background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: 4)
                ).padding(.horizontal, 80)
        }
    }
}




struct AddPage_Previews: PreviewProvider {
    @State static var isPresented : Bool = false
    @State static var bookData : BookData? = nil
    static var previews: some View {
        AddPage(isPresented: $isPresented, bookData: bookData).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

