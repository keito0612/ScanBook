//
//  AddModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/15.
//

import Foundation
import UIKit
import SwiftUI

enum shottingType: String, CaseIterable, Identifiable{
    case image = "写真"
    case scanner = "スキャナー"
    case recognized = "文字認識"
    
    var id: String { rawValue }
    var displayTitle: String {
      return rawValue
    }
}


class AddModel : ObservableObject{
    //タイトル
    @Published var titleText: String = ""
    @Published var titleErrorValidation:Bool = false
    @Published var titleErrorText: String = ""
    //カテゴリ
    @Published var category:String = ""
    let categoryItems:[String] = ["漫画","小説","書類"];
    let errorCategoryText = "※カテゴリーは必須項目です。"
    //本/漫画の表紙
    @Published var BookCovarImage:UIImage?
    @Published var categoryValidetion :Bool = false
    //撮影タイプ
    @Published var shootingType:Int?
    //写真
    @Published var imageArray:[UIImage] = []
    //ページ数
    @Published var pageCount:Int = 0;
    
    public func scanner(imageArray:Binding<[UIImage]>){
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
      let window = windowScene?.windows
        window?.filter({$0.isKeyWindow}).first?.rootViewController?.present(ScannerServise(imageArray: imageArray ).getDocumentCameraViewController(), animated: true)
    }
    
    public func add(){
        
    }
}
