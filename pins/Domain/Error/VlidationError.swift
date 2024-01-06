//
//  VlidationError.swift
//  pins
//
//  Created by 주동석 on 1/6/24.
//

import Foundation

enum ValidationErrors: Error {
    case invalidNicknameLength
    case invalidBirthDateLength
    case invalidBirthDateFormat
    case invalidDescriptionLength
}
