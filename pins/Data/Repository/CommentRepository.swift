//
//  CommentRepository.swift
//  pins
//
//  Created by 주동석 on 12/11/23.
//

import OSLog
import Foundation

protocol CommentRepositoryProtocol {
    func getComments(pinId: String) async -> [[String: Any]]
    func uploadComment(comment: [String: Any])
}

final class CommentRepository: CommentRepositoryProtocol {
    func getComments(pinId: String) async -> [[String: Any]] {
        let db = FirebaseFirestore.shared.db
        let commentRef = db.collection("comment")
        
        do {
            let result = try await commentRef.whereField("pinId", isEqualTo: pinId).getDocuments()
            var comments = [[String: Any]]()
            for document in result.documents {
                comments.append(document.data())
            }
            return comments
        } catch {
            os_log("Error getting documents: \(error)")
            fatalError("Error getting documents: \(error)")
        }
    }

    func uploadComment(comment: [String: Any]) {
        let db = FirebaseFirestore.shared.db
        let commentRef = db.collection("comment")
        commentRef.addDocument(data: comment)
    }
    
}
