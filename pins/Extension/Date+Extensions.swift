//
//  Date.swift
//  pins
//
//  Created by 주동석 on 2023/11/07.
//

import Foundation

extension Date {
    func currentDateTimeAsString() -> String {
        String.dateFormatter.locale = Locale.current

        String.dateFormatter.dateStyle = .long
        String.dateFormatter.timeStyle = .medium

        return String.dateFormatter.string(from: self)
    }
}
