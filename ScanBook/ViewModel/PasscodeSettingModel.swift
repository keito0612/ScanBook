//
//  PasscodeSettingModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/05/30.
//
import Foundation
import SwiftUI
class PasscodeSettingModel: ObservableObject{
    @AppStorage("isPassCodeLock") var isPassCodeLock:Bool = false
    @AppStorage("isFaceId") var isFaceId:Bool = false
    @Published var isShowAlert:Bool  = false
    @Published var alertMessage = ""
}
