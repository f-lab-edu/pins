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
    
    func uploadComment(_ text: String) throws {
        guard let currentPin else { return }
        do {
            try detailUseCase.uploadComment(text, pinId: currentPin.id)
        } catch {
            throw error
        }
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
