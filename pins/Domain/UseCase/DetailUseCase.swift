//
//  DetailUserCase.swift
//  pins
//
//  Created by 주동석 on 12/11/23.
//

import Foundation

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
    
    func getComments(pinId: String) async throws -> [CommentResponse] {
        var commentRequests: [CommentRequest] = []
        do {
            commentRequests = try await commentService.getComments(pinId: pinId)
        } catch {
            throw error
        }
        return try await withThrowingTaskGroup(of: CommentResponse?.self, returning: [CommentResponse].self) { group in
            var commentResponses: [CommentResponse] = []
            for commentRequest in commentRequests {
                group.addTask { [weak self] in
                    let user = try await self?.userService.getUser(id: commentRequest.userId)
                    guard let user else { throw UserError.userFetchError }
                    let profile = await self?.firestorageService.downloadImage(urlString: user.profileImage)
                    guard let profile else { throw UserError.userProfileImageNotFound }
                    return CommentResponse(commentRequest: commentRequest, user: user, profile: profile)
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
