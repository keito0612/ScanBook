//
//  LocalAuthServise.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/01.
//

import Foundation
import LocalAuthentication

class LocalAuthServise{
    
    var context: LAContext = LAContext()
    let description = "認証が必要です。"
    
    
    func auth(complation:@escaping(String) -> Void = {_ in },  failure:@escaping(String) -> Void = {_ in}) {
        // 顔認証が利用できるかチェック
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            // 認証処理の実行
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: description) { success, error in
                if success {
                    DispatchQueue.main.async {
                        complation("認証が成功しました")
                    }
                } else if let laError = error as? LAError {
                    switch laError.code {
                    case .authenticationFailed:
                        failure("認証に失敗しました")
                        break
                    case .userCancel:
                        failure("認証がキャンセルされました")
                        break
                    case .userFallback:
                        failure("認証に失敗しました")
                        break
                    case .systemCancel:
                        failure("認証が自動キャンセルされました")
                        break
                    case .passcodeNotSet:
                        failure("パスコードが入力されませんでした")
                        break
                    case .touchIDNotAvailable:
                        failure("指紋認証の失敗上限に達しました")
                        break
                    case .touchIDNotEnrolled:
                        failure("指紋認証が許可されていません")
                        break
                    case .touchIDLockout:
                        failure("指紋が登録されていません")
                        break
                    case .appCancel:
                        failure("アプリ側でキャンセルされました")
                        break
                    case .invalidContext:
                        failure("不明なエラー")
                        break
                    case .notInteractive:
                        failure("システムエラーが発生しました")
                        break
                    @unknown default:
                        break
                    }
                }
            }
        } else {
            failure("FaceIdの使用が許可されていません。設定アプリを開き、FaceIdの使用を許可してください。")
        }
    }
}


