//
//  ICloudSettingPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/20.
//

import Foundation
import SwiftUI
class ICloudSettingModel: ObservableObject {
    @AppStorage("iCloud") var iCloud:Bool = false
    @Published var isShowAlert:Bool  = false
    @Published var alertMessage = ""
}
