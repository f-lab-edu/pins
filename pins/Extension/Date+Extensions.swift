//
//  Date.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import Foundation

extension Date {
    func currentDateTimeAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium

        return dateFormatter.string(from: self)
    }
}
