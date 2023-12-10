//
//  CommentService.swift
//  pins
//
//  Created by 주동석 on 12/11/23.
//

import Foundation
import OSLog

protocol CommentServiceProtocol {
    func getComments(pinId: String) async -> [CommentRequest]
    func uploadComment(comment: CommentRequest)
}

final class CommentService: CommentServiceProtocol {
    private let commentRepository: CommentRepositoryProtocol
    
    init(commentRepository: CommentRepositoryProtocol) {
        self.commentRepository = commentRepository
    }
    
    func getComments(pinId: String) async -> [CommentRequest] {
        let jsonData = await commentRepository.getComments(pinId: pinId)
        let decoder = JSONDecoder()
        var returnComments: [CommentRequest] = []
        do {
            returnComments = try decoder.decode([CommentRequest].self, from: JSONSerialization.data(withJSONObject: jsonData))
        } catch {
            os_log("Error getting documents: \(error)")
        }
        return returnComments
    }
    
    func uploadComment(comment: CommentRequest) {
        let encoder = JSONEncoder()
        do {
            let commentData = try encoder.encode(comment)
            let commentDict = try JSONSerialization.jsonObject(with: commentData) as! [String: Any]
            commentRepository.uploadComment(comment: commentDict)
        } catch {
            os_log("Error getting documents: \(error)")
        }
    }
}
