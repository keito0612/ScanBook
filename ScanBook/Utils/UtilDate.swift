//
//  DateFormatter.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/20.
//

import Foundation
class UtilDate{
    private let dateFormatter = DateFormatter()
    init(){
        dateFormatter.dateFormat = "YYYY/MM/dd(E)HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ja_jp")
    }
    func DateTimeToString(date : Date) -> String {
        let dateTime = dateFormatter.string(from: date)
        return dateTime
    }
    func stringToDateTime(dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
}
