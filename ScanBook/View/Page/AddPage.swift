//
//  AddPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI

struct AddPage: View {
    init(isPresented: Binding<Bool>, bookDataItem :Binding<BookDataItem?>?) {
        _isPresented = isPresented
        self._bookDataItem =  bookDataItem ?? Binding.constant(nil)
        self.bookData = bookDataItem?.wrappedValue?.bookData
        self._addModel = StateObject( wrappedValue: AddModel(bookData: bookDataItem?.wrappedValue?.bookData))
    }
    @Binding var isPresented :Bool
    @Binding var bookDataItem : BookDataItem?
    
    let bookData: BookData?
    @StateObject var addModel: AddModel
    @Environment(\.managedObjectContext)private var context
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16){
                        //タイトル
                        TextFieldView(lavel: "タイトル", text: $addModel.titleText, errorValidation: $addModel.titleErrorValidation, errorText:addModel.titleErrorText , hintText: "本名、漫画名、レシート名", submit:{})
                        
                        Divider().frame(height: 2).background(Color.white)
                        //カテゴリー
                        DropDownView(value:$addModel.category , lavel: "カテゴリー", dropItemList: addModel.categoryItems, errorValidation: $addModel.categoryValidetion, errorText: addModel.errorCategoryText, onChange: {(value) in
                            if(value == "漫画"){
                                addModel.categoryStatus = 0
                            }else if(value == "小説"){
                                addModel.categoryStatus = 1
                            }else{
                                addModel.categoryStatus = 2
                            }
                        })
                        
                        Divider().frame(height: 2).background(Color.white)
                        if(addModel.category != "書類"){
                            BookCoverView(model: addModel)
                            Divider().frame(height: 2).background(Color.white)
                        }
                        BookPageAdd(model: addModel)
                        Divider().frame(height: 2).background(Color.white)
                        if(bookData == nil ){
                            AddButton(model: addModel, isPresented: $isPresented)
                        }else{
                            EditButton(model: addModel , bookDataItem: $bookDataItem)
                        }
                    }.padding(.large).navigationBarTitle(bookData == nil ? "追加": "編集" , displayMode: .inline)
                        .navigationDestination(isPresented: $addModel.isPresented ) {
                            PreviewPage(images: addModel.imageArray, bookData: nil).environment(\.managedObjectContext,context)
                        }
                        .toolbarBackground(Color.black,for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarColorScheme(.dark)
                        .customBackButton(onBack: {})
                }
                if(addModel.isLoading){
                    LoadingView(scaleEffect: 3)
                }
                CustomAlertView(alertType: addModel.alertType, title: addModel.alertTitle , message: addModel.alertMessage, isShow: $addModel.showAlert, onSubmit: {
                    if(addModel.alertType == .success){
                        if(bookDataItem == nil){
                            isPresented.toggle()
                        }else{
                            bookDataItem = nil
                        }
                    }
                })
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
                    .padding(.vertical, 8)
            } else{
                Image(uiImage: model.bookCovarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130).onTapGesture {
                        model.showingCovarImage.toggle()
                    }
                    .padding(.vertical, 8)
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
            Text(model.category == "書類" ? "現在の枚数": "現在のページ数").bold().padding(.top).font(.system(size: Bounds.width * 0.04)).foregroundColor(Color.white)
            Text(String(model.pageCount)).bold().font(.system(size:  Bounds.width * 0.14)).foregroundColor(Color.white)
            Button(action: {
                model.showingScan.toggle()
            }) {
                Text(model.category == "書類" ? "書類を追加する": "ページを追加する").font(.system(size: Bounds.width * 0.04)).bold().foregroundColor(Color.white).frame(height: Bounds.height * 0.07).frame(maxWidth: .infinity).background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 4)
                    ).padding(.horizontal, 8)
            }
            
            Button(action: {
                if(model.pageCount != 0){
                    model.isPresented = true
                }else{
                    model.pageErrorValidation = true
                }
            }) {
                Text("確認").font(.system(size: Bounds.width * 0.04)).bold().foregroundColor(Color.white).frame(height: Bounds.height * 0.07).frame(maxWidth: .infinity).background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 4)
                    ).padding(.medium)
            }
            if(model.pageErrorValidation){
                Text(model.pageErrorText)
                    .font(.system(size: Bounds.width * 0.035))
                    .bold()
                    .foregroundColor(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
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
    @Binding var bookDataItem:BookDataItem?
    @Environment(\.managedObjectContext)private var context
    var body: some View{
        Button(action: {
            if(model.isValidetion()){
                return
            }
            model.edit(context: context)
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
    @State static var bookDataItem : BookDataItem? = nil
    static var previews: some View {
        AddPage(isPresented: $isPresented, bookDataItem: $bookDataItem).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

