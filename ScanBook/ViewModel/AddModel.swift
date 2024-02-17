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
    @Published var bookCovarImage:UIImage = UIImage()
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
    
    
    public func add(context :NSManagedObjectContext){
        do{
            let newBookData = BookData(context: context)
            newBookData.id = UUID()
            newBookData.favorito = false
            newBookData.reading = false
            newBookData.title = titleText
            try context.save()
        }catch{
          print(error.localizedDescription)
        }
    }
}
