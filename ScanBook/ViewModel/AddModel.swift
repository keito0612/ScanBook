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
import BinaryCodable

extension Array where Element: UIImage {
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }

    static func decode(from data: Data) -> [UIImage] {
        let decodeUIImage = try? NSKeyedUnarchiver.unarchivedObject( ofClasses: [NSArray.self, UIImage.self], from: data) as? [UIImage]
        if(decodeUIImage != nil){
            return decodeUIImage!
        }else{
            return []
        }
    }
}

class AddModel : ObservableObject{
    init(bookData:BookData?) {
        self.bookData = bookData
        if(self.bookData != nil){
            titleText = self.bookData!.title!
            categoryStatus = self.bookData!.categoryStatus!
            category = categoryStatus
            if(category != "書類" ){
                bookCovarImage = UIImage(data: self.bookData!.coverImage!)!;
            }
            let images = Convert.convertImageArray(self.bookData!.images)
            if(!images.isEmpty){
                for image in Convert.convertImageArray(self.bookData!.images) {
                    let imageData :(image:UIImage, memo:String) = (image:UIImage(data: image.image!)!, memo:image.memo!)
                    imageArray.append(imageData)
                }
            }
            if(imageArray.count != 0){
                pageCount = imageArray.count
            }
        }
    }
    //タイトル
    @Published var titleText: String = ""
    @Published var titleErrorValidation:Bool = false
    @Published var titleErrorText: String = "※タイトルは必須項目です。"
    @Published var openMenu:Bool = false
    //カテゴリ
    @Published var category:String = ""
    @Published var categoryAlertText:String = ""
    var categoryStatus: String = ""
    var categoryItems:[Category] = [];
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
    @Published var imageArray:[(image:UIImage, memo:String)] = []
    //ページ数
    @Published var pageCount:Int = 0;
    @Published var pageErrorText: String = "※ページを追加してください。"
    @Published var pageErrorValidation:Bool = false
    //画面遷移フラグ
    @Published var isPresented :Bool = false
    //アラート表示フラグ
    @Published var showAlert: Bool = false
    @Published var showAddCategoryAlert: Bool = false
    //アラートタイトル
    @Published var alertTitle: String = ""
    //アラートメッセージ
    @Published var alertMessage : String = ""
    //アラートタイプ
    @Published var alertType :AlertType = .success
    //ローディング
    @Published var isLoading :Bool = false
    
    let bookData: BookData?
    
    
    public func getCategory() -> [Category]{
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            let categorys = try context.fetch(request)
            return categorys
        }
        catch {
            fatalError()
        }
    }
    
    func addCategory(name: String) {
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
          let newCategory = Category(context: context)
          newCategory.id = UUID()
          newCategory.name = name
          newCategory.date = Date()
          do {
              try context.save()
          } catch {
              print("エラー: \(error.localizedDescription)")
          }
      }
    
    public func add(context :NSManagedObjectContext){
        isLoading = true
        do{
            let newBookData = BookData(context: context)
            newBookData.id = UUID()
            newBookData.favorito = false
            newBookData.reading = false
            newBookData.title = titleText
            newBookData.coverImage = bookCovarImage.jpegData(compressionQuality: 1)
            newBookData.categoryStatus = categoryStatus
            newBookData.date = Date()
            newBookData.pageCount = Int16(0)
            for image in imageArray{
                let imageData : Data = image.image.pngData()!
                addImageToBook(bookData: newBookData, memo: image.memo, imageData: imageData, context: context)
            }
            try context.save()
            isLoading = false
            showAlert = true
            alertType = .success
            alertTitle = "作成しました。"
        }catch{
            print(error.localizedDescription)
            isLoading = false
            showAlert = true
            alertType = .error
            alertTitle = "エラーが発生しました。"
        }
    }
    
    
    private func addImageToBook(bookData: BookData, memo: String, imageData: Data, context:NSManagedObjectContext) {
        let newImage = Image(context: context)
        newImage.id = Int64(UUID().uuidString)!
        newImage.memo = memo
        newImage.image = imageData
        bookData.addToImages(newImage)
    }
    
    func editImageToBook(context:NSManagedObjectContext){
        bookData?.removeFromImages(bookData!.images!)
        for image in imageArray{
            let imageData :Data  =  image.image.pngData()!
            addImageToBook(bookData:bookData!, memo: image.memo, imageData: imageData , context: context)
        }
    }
    
    
    public func edit(context : NSManagedObjectContext){
        isLoading = true
        do{
            bookData!.title = titleText
            bookData!.categoryStatus = categoryStatus
            bookData!.coverImage = bookCovarImage.jpegData(compressionQuality: 1)
            bookData!.date = Date()
            editImageToBook(context: context)
            try context.save()
            isLoading = false
            showAlert = true
            alertType = .success
            alertTitle = "編集しました。"
        }catch{
            print(error.localizedDescription)
            isLoading = false
            showAlert = true
            alertType = .error
            alertTitle = "エラーが発生しました。"
        }
    }
    
    public func isValidetion() -> Bool{
        var valide:Bool = false
        titleErrorValidation = false
        categoryValidetion = false
        pageErrorValidation = false
        
        //タイトル
        if(titleText.isEmpty){
            titleErrorValidation = true
            valide = true
            return valide
        }
        //カテゴリー
        if(categoryStatus.isEmpty){
            categoryValidetion = true
            valide = true
            return valide
        }
        
        
        //ページ数
        if(pageCount == 0){
            pageErrorValidation = true
            valide = true
            return valide
        }
        
        return valide
    }
}
