//
//  passCheck.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/05.
//

import Foundation
class PassCheck: ObservableObject{
    @Published  var firstCheck:[String?] = [nil, nil, nil, nil]
    @Published  var secondCheck:[String?] = [nil, nil, nil, nil]
    var passText:String = "パスワードを忘れると復元できません\n忘れないようご注意ください"
}
