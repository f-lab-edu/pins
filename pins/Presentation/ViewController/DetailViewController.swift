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
    private lazy var viewModel: DetailViewModel = DetailViewModel(detailUseCase: detailUseCase)
    private var cancellable = Set<AnyCancellable>()
    
    private var detailView: DetailView {
        view as! DetailView
    }
    
    override func loadView() {
        view = DetailView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$currentPin.sink { [weak self] pin in
            guard let pin = pin else { return }
            self?.detailView.setPinInfoDepondingOnImageExistence(pin: pin)
        }.store(in: &cancellable)
        
        setAction()
        getComments()
    }
    
    func setAction() {
        detailView.navigationView.setBackButtonAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        detailView.commentView.setSubmitButtonAction(UIAction(handler: { [weak self] _ in
            let comment = self?.detailView.commentView.inputTextView.text
            guard let comment else { return }
            guard !comment.isEmpty else { return }
            self?.viewModel.uploadComment(comment)
            self?.detailView.commentView.inputTextView.text = ""
            self?.getComments()
        }))
    }
    
    func setPin(pin: PinResponse) {
        viewModel.currentPin = pin
        viewModel.setIsImage(value: !pin.images.isEmpty)
    }
    
    func getComments() {
        Task {
            await viewModel.getComments()
        }
    }
}

extension DetailViewController: UITextFieldDelegate {
}
