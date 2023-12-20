//
//  DetailViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/11/27.
//

import UIKit

final class DetailViewModel {
    @Published var currentPin: PinResponse?
    @Published var isImage: Bool = false
    @Published var page: Int = 1
    
    @Published var comments: [CommentResponse] = []
    private let detailUseCase: DetailUseCaseProtocol
    
    init(detailUseCase: DetailUseCaseProtocol) {
        self.detailUseCase = detailUseCase
    }
    
    func setIsImage(value: Bool) {
        isImage = value
    }
    
    func setPage(value: Int) {
        page = value
    }
    
    func getImages() -> [UIImage] {
        guard let currentPin = currentPin else { return [] }
        return currentPin.images
    }
    
    func uploadComment(_ text: String) {
        guard let currentPin else { return }
        detailUseCase.uploadComment(text, pinId: currentPin.id)
    }
    
    func getComments() async throws {
        guard let currentPin else { return }
        do {
            comments = try await detailUseCase.getComments(pinId: currentPin.id)
        } catch {
            throw error
        }
    }
}
