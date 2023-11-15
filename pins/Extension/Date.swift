//
//  Date.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import Foundation

extension Date {
    func currentDateTimeAsString() -> String {
        let dataFormatter = DateFormatter()
        dataFormatter.locale = Locale(identifier: "ko_KR")
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dataFormatter.string(from: self)
    }
}
