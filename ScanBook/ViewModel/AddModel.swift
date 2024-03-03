//
//  AddModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/15.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

class AddModel : ObservableObject{
    init(bookData:BookData?) {
        self.bookData = bookData
        if(self.bookData != nil){
            titleText = self.bookData!.title!
            categoryStatus = Int(self.bookData!.categoryStatus)
            category = categoryItems[categoryStatus!]
            bookCovarImage = UIImage(data: self.bookData!.coverImage!)!;
            imageArray = Convert.convertBase64ToImages(self.bookData!.images!.components(separatedBy: ","))
            if(imageArray.count != 0){
                pageCount = imageArray.count
            }
        }
    }
    //タイトル
    @Published var titleText: String = ""
    @Published var titleErrorValidation:Bool = false
    @Published var titleErrorText: String = "※タイトルは必須項目です。"
    //カテゴリ
    @Published var category:String = ""
    var categoryStatus: Int?
    let categoryItems:[String] = ["漫画","小説","書類"];
    let errorCategoryText = "※カテゴリーは必須項目です。"
    //本/漫画の表紙
    @Published var bookCovarImage: UIImage = UIImage()
    @Published var categoryValidetion :Bool = false
    //スキャン
    @Published var showingScan = false
    @Published var showingCovarImage = false
    //撮影タイプ
    @Published var shootingTypeText:String = ""
    @Published var shootingTypeItems:[String] = ["文字認識","スキャン"]
    //写真
    @Published var imageArray:[UIImage] = []
    //ページ数
    @Published var pageCount:Int = 0;
    @Published var pageErrorText: String = "※ページを追加してください。"
    @Published var pageErrorValidation:Bool = false
    //画面遷移フラグ
    @Published var isPresented = false
    
    let bookData: BookData?
    
    
    public func add(context :NSManagedObjectContext){
        do{
            let newBookData = BookData(context: context)
            newBookData.id = UUID()
            newBookData.favorito = false
            newBookData.reading = false
            newBookData.title = titleText
            newBookData.coverImage = bookCovarImage.jpegData(compressionQuality: 1)
            newBookData.categoryStatus = Int64(categoryStatus!)
            newBookData.images = Convert.convertImagesToBase64(imageArray).joined(separator: ",")
            newBookData.date = Date()
            try context.save()
        }catch{
          print(error.localizedDescription)
        }
    }
    public func edit(context : NSManagedObjectContext){
        do{
            bookData!.title = titleText
            bookData!.categoryStatus = Int64(categoryStatus!)
            bookData!.coverImage = bookCovarImage.jpegData(compressionQuality: 1)
            bookData!.images = Convert.convertImagesToBase64(imageArray).joined(separator: ",")
            bookData!.date = Date()
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
  public func isValidetion() -> Bool{
        var valide:Bool = false
        titleErrorValidation = false
        categoryValidetion = false
        pageErrorValidation = false
        
        //ページ数
        if(pageCount == 0){
            pageErrorValidation = true
            valide = true
            return valide
        }
        
        //タイトル
        if(titleText.isEmpty){
            titleErrorValidation = true
            valide = true
            return valide
        }
        //カテゴリー
        if(categoryStatus == nil){
            categoryValidetion = true
            valide = true
            return valide
        }
        return valide
    }
}
