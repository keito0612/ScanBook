//
//  LibraryModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/03.
//

import Foundation
class LibraryModel :ObservableObject{
    @Published var searchText = ""
    @Published var isPresented: Bool = false
}
