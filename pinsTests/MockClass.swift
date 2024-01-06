//
//  MockClass.swift
//  pinsTests
//
//  Created by 주동석 on 12/19/23.
//

import UIKit
@testable import pins

final class MockUserService: UserServiceProtocol {
    func putUser(user: pins.UserRequest) {
        fatalError("Not implemented")
    }
    
    var mockUser: UserRequest = UserRequest(id: "testId", nickName: "testNickname", firstTime: false, profileImage: "testImage")

    func getUser(id: String) async -> UserRequest? {
        if "testId" == mockUser.id {
            return mockUser
        }
        return nil
    }
}

final class MockFirestorageService: FirestorageServiceProtocol {
    func uploadImage(imageInfo: pins.ImageInfo) async -> pins.URLWithIndex {
        fatalError("Not implemented")
    }
    
    func uploadImages(imageInfos: [pins.ImageInfo]) async -> [pins.URLWithIndex] {
        fatalError("Not implemented")
    }
    
    func createPin(pin: pins.PinRequest, images: [pins.ImageInfo]) async {
        fatalError("Not implemented")
    }
    
    var mockPins: [PinRequest] = [PinRequest(id: "testId", title: "testTitle", content: "testContent", longitude: 0.0, latitude: 0.0, category: "testCategory", created: "testCreated", userId: "testUserId", urls: ["testUrl"])]
    var mockImage: UIImage = UIImage() // 테스트를 위한 기본 이미지

    func getPins() async -> [PinRequest] {
        return mockPins
    }

    func downloadImage(urlString: String) async -> UIImage? {
        return mockImage
    }
}

final class MockCommentService: CommentServiceProtocol {
    var mockComment: [CommentRequest] = [CommentRequest(id: "testId", pinId: "testPin", userId: "testUserId", content: "testComment", createdAt: Date())]
    func getComments(pinId: String) async -> [pins.CommentRequest] {
        return mockComment
    }
    
    func uploadComment(comment: pins.CommentRequest) {
        fatalError("Not implemented")
    }
}
