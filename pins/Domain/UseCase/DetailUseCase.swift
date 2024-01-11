//
//  DetailUserCase.swift
//  pins
//
//  Created by 주동석 on 12/11/23.
//

import Foundation
import PinsUtilKit

protocol DetailUseCaseProtocol {
    func uploadComment(_ text: String, pinId: String) throws
    func getComments(pinId: String) async throws -> [CommentResponse]
}

final class DetailUseCase: DetailUseCaseProtocol {
    private var firestorageService: FirestorageServiceProtocol
    private let commentService: CommentServiceProtocol
    private let userService: UserServiceProtocol
    
    init(commentService: CommentServiceProtocol, userService: UserServiceProtocol, firestorageSerive: FirestorageServiceProtocol) {
        self.commentService = commentService
        self.userService = userService
        self.firestorageService = firestorageSerive
    }
    
    func uploadComment(_ text: String, pinId: String) throws {
        let userId = KeychainManager.load(key: .userId)
        guard let userId else { return }
        do {
        try commentService.uploadComment(comment: CommentRequest(
            id: UUID().uuidString,
            pinId: pinId,
            userId: userId,
            content: text,
            createdAt: Date()))
        } catch {
            throw error
        }
    }
    
    func fetchCommentRequests(pinId: String) async throws -> [CommentRequest] {
        return try await commentService.getComments(pinId: pinId)
    }

    func processCommentRequest(_ commentRequest: CommentRequest) async throws -> CommentResponse {
        let user = try await userService.getUser(id: commentRequest.userId)
        guard let user else { throw UserError.userFetchError }
        let profile = await firestorageService.downloadImage(urlString: user.profileImage)
        guard let profile else { throw UserError.userProfileImageNotFound }
        return CommentResponse(commentRequest: commentRequest, user: user, profile: profile)
    }

    func getComments(pinId: String) async throws -> [CommentResponse] {
        let commentRequests = try await fetchCommentRequests(pinId: pinId)
        return try await withThrowingTaskGroup(of: (Int, CommentResponse?).self, returning: [CommentResponse].self) { group in
            var commentResponses: [(Int, CommentResponse)] = []
            for (index, commentRequest) in commentRequests.enumerated() {
                group.addTask { [weak self] in
                    let response = try await self?.processCommentRequest(commentRequest)
                    return (index, response)
                }
            }
            for try await (index, response) in group {
                if let response = response {
                    commentResponses.append((index, response))
                }
            }
            return commentResponses.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
        }
    }
}
