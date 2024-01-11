//
//  CommentResponse.swift
//  pins
//
//  Created by 주동석 on 12/11/23.
//

import UIKit

struct CommentResponse {
    let id: String
    let pinId: String
    let userId: String
    let userName: String
    let userAge: Int
    let userProfile: UIImage
    let userDescription: String
    let content: String
    let createdAt: String
    
    init(id: String, pinId: String, userId: String, userName: String, userAge: Int, userProfile: UIImage, userDescription: String, content: String, createdAt: String) {
        self.id = id
        self.pinId = pinId
        self.userId = userId
        self.userName = userName
        self.userAge = userAge
        self.userProfile = userProfile
        self.userDescription = userDescription
        self.content = content
        self.createdAt = createdAt
    }
    
    init(commentRequest: CommentRequest, user: UserRequest, profile: UIImage) {
        self.id = commentRequest.id
        self.pinId = commentRequest.pinId
        self.userId = user.id
        self.userName = user.nickName
        self.userAge = user.birthDate?.birthDateToAge() ?? 0
        self.userProfile = profile
        self.userDescription = user.description ?? ""
        self.content = commentRequest.content
        self.createdAt = commentRequest.createdAt.currentDateTimeAsString().convertDaysAgo()
    }
}
