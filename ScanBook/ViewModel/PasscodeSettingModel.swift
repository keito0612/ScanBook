//
//  PasscodeSettingModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/05/30.
//
import Foundation
class PasscodeSettingModel: ObservableObject{
    @Published var isPassCodeLock:Bool = false
    @Published var isFaceId:Bool = false
}
