//
//  UserResponse.swift
//  pins
//
//  Created by 주동석 on 12/7/23.
//

import UIKit

struct UserResponse {
    var id: String
    var nickName: String
    var email: String?
    var birthDate: String?
    var description: String?
    var firstTime: Bool
    var profileImage: UIImage?
    
    init(id: String, nickName: String, email: String, firstTime: Bool) {
        self.id = id
        self.nickName = nickName
        self.email = email
        self.firstTime = firstTime
    }
    
    init(user: UserRequest, image: UIImage, firstTime: Bool) {
        self.id = user.id
        self.nickName = user.nickName
        self.email = user.email
        self.description = user.description
        self.firstTime = firstTime
        self.profileImage = image
    }
}
