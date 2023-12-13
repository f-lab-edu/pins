//
//  User.swift
//  pins
//
//  Created by 주동석 on 2023/11/17.
//

import Foundation

struct UserRequest: Codable, Equatable {
    var id: String
    var nickName: String
    var email: String?
    var birthDate: String?
    var description: String?
    var firstTime: Bool
    var profileImage: String
}
