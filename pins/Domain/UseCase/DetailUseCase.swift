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
            createdAt: Date().currentDateTimeAsString()))
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
        return try await withThrowingTaskGroup(of: CommentResponse?.self, returning: [CommentResponse].self) { group in
            var commentResponses: [CommentResponse] = []
            for commentRequest in commentRequests {
                group.addTask { [weak self] in
                    return try await self?.processCommentRequest(commentRequest)
                }
            }
            for try await response in group {
                if let response = response {
                    commentResponses.append(response)
                }
            }
            return commentResponses
        }
    }
}
