//
//  AddPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI

struct AddPage: View {
    @Binding var isPresented :Bool
    @Binding var bookDataItem : BookDataItem?
    @StateObject var addModel: AddModel
    @Environment(\.managedObjectContext)private var context
    @FetchRequest(
       entity: Category.entity(),
       sortDescriptors: [NSSortDescriptor(keyPath: \Category.id, ascending: false)],
       animation: .default
     ) var categorys: FetchedResults<Category>
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
                        CustomMenu(isMenuOpen: $addModel.openMenu, value: $addModel.categoryStatus, errorValidation: $addModel.categoryValidetion, title: "カテゴリー", errorText: addModel.errorCategoryText, menuItems:addModel.categoryItems , onChange:{ value in
                            addModel.categoryStatus = value
                        }, plusOnTap: {
                            addModel.showAddCategoryAlert.toggle()
                        }).zIndex(1)
                        
                        Divider().frame(height: 2).background(Color.white)
                        if(addModel.categoryStatus != "書類"){
                            BookCoverView(model: addModel)
                            Divider().frame(height: 2).background(Color.white)
                        }
                        BookPageAdd(model: addModel)
                        Divider().frame(height: 2).background(Color.white)
                        if(bookDataItem == nil ){
                            AddButton(model: addModel, isPresented: $isPresented)
                        }else{
                            EditButton(model: addModel , bookDataItem: $bookDataItem)
                        }
                    }.padding(.large).navigationBarTitle(bookDataItem == nil ? "作成": "編集" , displayMode: .inline)
                        .navigationDestination(isPresented: $addModel.isPresented ) {
                            PreviewPage(images: addModel.imageArray, bookData: nil).environment(\.managedObjectContext,context)
                        }
                        .toolbarBackground(Color.black,for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbarColorScheme(.dark)
                        .customBackButton(onBack: {})
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
                ScannerView(scannedImage: $addModel.bookCovarImage, multiCapture: true, isScanning: $addModel.showingScan,  completion: { images in
                    for image  in images{
                        addModel.imageArray.append((image, ""))
                    }
                    addModel.pageCount =  addModel.imageArray.count
                })
            }
            .sheet(isPresented:$addModel.showingCovarImage ){
                ScannerView(scannedImage: $addModel.bookCovarImage, multiCapture: false, isScanning: $addModel.showingCovarImage,  completion: { _ in
                })
            }
            .alert("カテゴリーを追加", isPresented: $addModel.showAddCategoryAlert) {
                TextField( "新しいカテゴリ名", text: $addModel.categoryAlertText)
                
                HStack {
                    Button {
                        addModel.categoryAlertText = ""
                        addModel.showAddCategoryAlert = false
                    } label: {
                        Text("キャンセル")
                    }
                    Button {
                        addModel.addCategory(name: addModel.categoryAlertText)
                        addModel.categoryItems =   addModel.getCategory()
                        addModel.categoryAlertText = ""
                        addModel.showAddCategoryAlert = false
                    } label: {
                        Text("追加")
                    }
                }
            }
        }.onAppear(perform: {
            addModel.categoryItems =   addModel.getCategory()
        })
    }
}

struct BookCoverView :View{
    @ObservedObject var model:AddModel
    var body: some View{
        VStack{
            Text("本 / 漫画の表紙")
                .bold()
                .foregroundColor(Color.white)
                .font(.system(size: Bounds.height * 0.02))
                .frame(maxWidth: .infinity, alignment: .leading)
            if(model.bookCovarImage.size == CGSize.zero){
                Button(action: {
                    model.showingCovarImage.toggle()
                }, label: {
                    Image(systemName: "camera")
                        .font(.system(size: Bounds.height * 0.06, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: Bounds.height * 0.2, height: Bounds.height * 0.2).onTapGesture {
                            model.showingCovarImage.toggle()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 10)
                        )
                        .cornerRadius(30)
                        .background(.black)
                }).padding(.vertical, 8)
            } else{
                Image(uiImage: model.bookCovarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Bounds.height * 0.2, height: Bounds.height * 0.2).onTapGesture {
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
            Text( model.categoryStatus == "書類" ?  "書類の追加"  : "ページの追加")
                .bold()
                .font(.system(size: Bounds.height * 0.02))
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(model.categoryStatus == "書類" ? "現在の枚数": "現在のページ数").bold().padding(.top).font(.system(size: Bounds.width * 0.04)).foregroundColor(Color.white)
            Text(String(model.pageCount)).bold().font(.system(size:  Bounds.width * 0.14)).foregroundColor(Color.white)
            Button(action: {
                model.showingScan.toggle()
            }) {
                Text(model.categoryStatus == "書類" ? "書類を追加する": "ページを追加する").font(.system(size: Bounds.width * 0.04)).bold().foregroundColor(Color.white).frame(height: Bounds.height * 0.07).frame(maxWidth: .infinity).background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: Bounds.width * 0.1)
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
                        RoundedRectangle(cornerRadius: Bounds.width * 0.1)
                            .stroke(Color.white, lineWidth: 4)
                    ).padding(.medium)
            }
            if(model.pageErrorValidation){
                Text(model.pageErrorText)
                    .font(.system(size: Bounds.width * 0.03))
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
            Text("作成").font(.system(size: Bounds.width * 0.04)).bold().foregroundColor(Color.white).frame(height: Bounds.height * 0.07).frame(maxWidth: .infinity).background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: Bounds.width * 0.07)
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
            Text("編集").bold().font(.system(size: Bounds.width * 0.04)).foregroundColor(Color.white).frame(height:  Bounds.height * 0.07).frame(maxWidth: .infinity).background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: Bounds.width * 0.07)
                        .stroke(Color.white, lineWidth: 4)
                ).padding(.horizontal, 80)
        }
    }
}




struct AddPage_Previews: PreviewProvider {
    @State static var isPresented : Bool = false
    @State static var bookDataItem : BookDataItem? = nil
    static var previews: some View {
        AddPage(isPresented: $isPresented, bookDataItem: $bookDataItem, addModel:  AddModel(bookData: bookDataItem?.bookData) ).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

