//
//  Comment.swift
//  pins
//
//  Created by 주동석 on 12/11/23.
//

import Foundation

struct CommentRequest: Codable {
    let id: String
    let pinId: String
    let userId: String
    let content: String
    let createdAt: String
}
