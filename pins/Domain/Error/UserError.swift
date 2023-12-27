//
//  UserError.swift
//  pins
//
//  Created by 주동석 on 12/16/23.
//

import Foundation

enum UserError: Error {
    case userIdNotFound
    case userFetchError
    case userProfileImageNotFound
    case userDecodingError
}
