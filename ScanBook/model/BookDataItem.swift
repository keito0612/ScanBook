//
//  BookItem.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/05/14.
//

enum Page{
    case preview
    case edit
}

import Foundation
struct BookDataItem: Identifiable {
    let id = UUID()
    let page: Page
    let bookData: BookData
}
