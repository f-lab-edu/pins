//
//  SigninViewController.swift
//  pins
//
//  Created by 주동석 on 12/2/23.
//

import UIKit

class SigninViewController: UIViewController {
    private let viewModel: SigninViewModel = SigninViewModel()
    private var signinView: SigninView {
        view as! SigninView
    }
    
    override func loadView() {
        view = SigninView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActions()
    }
    
    private func setActions() {
        signinView.setSubmitButtonAction(UIAction(handler: { [weak self] _ in
            print(self?.viewModel.getInputStep())
            switch self?.viewModel.getInputStep() {
            case .nickName:
                self?.viewModel.setInputStep(.birthDate)
            case .description:
                print("서버에 유저 정보 저장")
            default:
                break
            }
        }))
    }
}
