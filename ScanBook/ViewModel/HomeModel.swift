//
//  HomeModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/04/01.
//

import Foundation

class HomeModel: ObservableObject{
    @Published var isPresentPreview: Bool = false
    @Published var selectedReadingBookDataItem:BookDataItem?
    @Published var selectedFavoriteBookDataItem:BookDataItem?
    func getCategoryStatusText(_ status : Int64 ) -> String{
        switch status {
          case 0:
            return "漫画"
          case 1:
            return "小説"
          default:
            return "書類"
        }
    }
}

