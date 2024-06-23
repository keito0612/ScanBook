//
//  CheckIcloudServise.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/06/19.
//

import Foundation
import CloudKit
class CheckIcloudServise{
    static func checkICloudAvailability(failure:@escaping(String)-> Void) {
        let container = CKContainer.default()
        container.accountStatus { (status, error) in
            DispatchQueue.main.async {
                switch status {
                case .available:
                     break
                case .noAccount:
                    failure("iCloudアカウントが設定されていません")
                case .restricted:
                    failure("iCloudは制限されています")
                case .couldNotDetermine:
                    failure("iCloudアカウントのステータスを判断できませんでした")
                case .temporarilyUnavailable:
                    failure("一時的にicloudのアクセスが集中しているため、少し時間が経ってから再度試してください。")
                @unknown default:
                    failure("An unknown error occurred")
                }
            }
        }
    }
}
