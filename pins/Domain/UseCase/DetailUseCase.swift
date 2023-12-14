//
//  DetailUserCase.swift
//  pins
//
//  Created by 주동석 on 12/11/23.
//

import Foundation

protocol DetailUseCaseProtocol {
    func uploadComment(_ text: String, pinId: String)
    func getComments(pinId: String) async -> [CommentResponse]
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
    
    func uploadComment(_ text: String, pinId: String) {
        let userId = KeychainManager.load(key: .userId)
        guard let userId else { return }
        commentService.uploadComment(comment: CommentRequest(
            id: UUID().uuidString,
            pinId: pinId,
            userId: userId,
            content: text,
            createdAt: Date().currentDateTimeAsString()))
    }
    
    func getComments(pinId: String) async -> [CommentResponse] {
        let commentRequests = await commentService.getComments(pinId: pinId)
        
        var commentResponses: [CommentResponse] = []
        
        for commentRequest in commentRequests {
            let user = await userService.getUser(id: commentRequest.userId)
            guard let user else { fatalError("Error feching user") }
            let profile = await firestorageService.downloadImage(urlString: user.profileImage)
            guard let profile else { fatalError("Error feching profile") }
            commentResponses.append(CommentResponse(commentRequest: commentRequest, user: user, profile: profile))
        }
        return commentResponses
    }
}
