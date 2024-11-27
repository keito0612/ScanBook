//
//  AppearanceModeSetting.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/11/26.
//

import Foundation
import SwiftUICore


enum DarkModeSetting: Int {
    case normal = 0
    case darkMode = 1
    case lightMode = 2
    
    func text() -> String{
        switch self {
        case .normal:
            return  "デフォルト"
        case .darkMode:
            return  "ダーク"
        case .lightMode:
            return  "ライト"
        }
    }
    
    func backGroundColor () -> Color {
        switch self{
        case .normal:
            .black
        case .darkMode:
            .black
        case .lightMode:
            .white
        }
    }
    func foregroundColor () -> Color {
        switch self{
        case .normal:
            .white
        case .darkMode:
            .white
        case .lightMode:
            .black
        }
    }
}
