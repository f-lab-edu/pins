//
//  String+Extensions.swift
//  pins
//
//  Created by 주동석 on 2023/11/28.
//

import Foundation

extension String {
    static let dateFormatter = DateFormatter()
    func convertDaysAgo() -> String {
        let dateFormatsWithLocale = [
            ("yyyy년 MM월 dd일 a hh:mm:ss", "ko_KR"),
            ("yyyy년 MM월 dd일 HH:mm:ss", "ko_KR"),
            ("MMMM dd, yyyy 'at' h:mm:ss a", "en_US_POSIX")
        ]

        var date: Date?
        for (format, localeIdentifier) in dateFormatsWithLocale {
            String.dateFormatter.dateFormat = format
            String.dateFormatter.locale = Locale(identifier: localeIdentifier)
            if let formattedDate = String.dateFormatter.date(from: self) {
                date = formattedDate
                break
            }
        }

        guard let validDate = date else {
            return "유효하지 않은 날짜"
        }

        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: validDate, to: now)

        if let daysAgo = components.day, daysAgo > 0 {
            return "\(daysAgo)일 전"
        } else if let hoursAgo = components.hour, hoursAgo > 0 {
            return "\(hoursAgo)시간 전"
        } else if let minutesAgo = components.minute, minutesAgo > 0 {
            return "\(minutesAgo)분 전"
        } else if let secondsAgo = components.second, secondsAgo > 0 {
            return "\(secondsAgo)초 전"
        } else {
            return "방금 전"
        }
    }
    
    func birthDateToAge() -> Int {
        String.dateFormatter.dateFormat = "yyMMdd"
        let birthDate = String.dateFormatter.date(from: self)
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate!, to: Date())
        let age = ageComponents.year!
        return age
    }
}
