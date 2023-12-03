//
//  User.swift
//  pins
//
//  Created by 주동석 on 2023/11/17.
//

import Foundation

struct User: Codable {
    var id: String
    var name: String?
    var email: String?
    var birthDate: String?
    var description: String?
    var firstTime: Bool
}
