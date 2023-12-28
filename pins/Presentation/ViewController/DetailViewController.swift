//
//  DetailViewController.swift
//  pins
//
//  Created by 주동석 on 2023/11/24.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    private lazy var userRepository: UserRepositoryProtocol = UserRepository()
    private lazy var firebaseRepository: FirebaseRepositoryProtocol = FirebaseRepository()
    private lazy var commentRepository: CommentRepositoryProtocol = CommentRepository()
    
    private lazy var firestorageService: FirestorageServiceProtocol = FirestorageService(firebaseRepository: firebaseRepository)
    private lazy var userService: UserServiceProtocol = UserService(userRepository: userRepository)
    private lazy var commentService: CommentServiceProtocol = CommentService(commentRepository: commentRepository)
    
    private lazy var detailUseCase: DetailUseCaseProtocol = DetailUseCase(commentService: commentService, userService: userService, firestorageSerive: firestorageService)
    lazy var viewModel: DetailViewModel = DetailViewModel(detailUseCase: detailUseCase)
    private var cancellable = Set<AnyCancellable>()
    
    enum ScrollViewType: Int {
        case totalScroll
        case imageBannerScroll
    }
    
    private var detailView: DetailView {
        view as! DetailView
    }
    
    override func loadView() {
        view = DetailView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setAction()
        setBinding()
        getComments()
    }
    
    private func setDelegate() {
        detailView.scrollView.delegate = self
        detailView.bannerScrollView.delegate = self
    }
    
    private func setBinding() {
        viewModel.$currentPin.sink { [weak self] pin in
            guard let pin = pin else { return }
            self?.detailView.setPinInfoDepondingOnImageExistence(pin: pin)
        }.store(in: &cancellable)
        
        viewModel.$page.sink { [weak self] value in
            self?.detailView.imageCountLabel.text = "\(value)/\(self?.viewModel.getImages().count ?? 0)"
        }.store(in: &cancellable)
        
        viewModel.$comments.receive(on: DispatchQueue.main)
            .sink { [weak self] comments in
                self?.detailView.contentView.setComments(comments: comments, scrollView: self?.detailView.scrollView)
        }.store(in: &cancellable)
    }
    
    private func setAction() {
        detailView.navigationView.setBackButtonAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        detailView.commentView.setSubmitButtonAction(UIAction(handler: { [weak self] _ in
            Task {
                let comment = self?.detailView.commentView.inputTextView.text
                guard let comment else { return }
                guard !comment.isEmpty else { return }
                try self?.viewModel.uploadComment(comment)
                self?.detailView.commentView.inputTextView.text = ""
                self?.getComments()
            }
        }))
    }
    
    func setPin(pin: PinResponse) {
        viewModel.currentPin = pin
        viewModel.setIsImage(value: !pin.images.isEmpty)
    }
    
    func getComments() {
        Task {
            try await viewModel.getComments()
        }
    }
}

// MARK: - Extensions
extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderGray {
            textView.text = nil
            textView.textColor = .defaultText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "댓글을 입력해주세요."
            textView.textColor = .placeholderGray
        }
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch ScrollViewType(rawValue: scrollView.tag) {
        case .imageBannerScroll:
            let page = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            viewModel.setPage(value: page + 1)
            detailView.updateImageZIndex(page: page)
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch ScrollViewType(rawValue: scrollView.tag) {
        case .totalScroll:
            let yOffset = scrollView.contentOffset.y
            detailView.navigationView.changeBackgroundColor(as: yOffset)
            if viewModel.isImage {
                detailView.navigationView.changeButtonTintColor(as: yOffset)
                detailView.updateImageScale(yOffset)
            }
        default:
            break
        }
    }
}
