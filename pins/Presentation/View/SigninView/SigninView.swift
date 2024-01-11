//
//  SigninView.swift
//  pins
//
//  Created by 주동석 on 12/2/23.
//

import OSLog
import UIKit
import Combine

final class SigninView: UIView {
    // MARK: - Properties
    private let animationManager: AnimationManager = AnimationManager()
    private let viewModel: SigninViewModel
    let signinProfileView: SigninProfileView = SigninProfileView()
    let signinDescriptionView: SigninTextInput = SigninTextInput(name: "자기소개", placeholder: "자기소개를 입력해주세요.")
    let signinBirthdateView: SigninTextInput = SigninTextInput(name: "생년월일", placeholder: "생년월일을 입력해주세요.")
    let signinNicknameView: SigninTextInput = SigninTextInput(name: "닉네임", placeholder: "닉네임을 입력해주세요")
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "만나서 반가워요! \n아래 정보를 입력해주세요."
        label.textColor = .defaultText
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.setLineHeight(lineHeight: 10)
        return label
    }()
    let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("확인", for: .normal)
        return button
    }()
    // MARK: - Lifecycle
    init(viewModel: SigninViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .defaultBackground
        setLayout()
        setKeyboardObserver()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    // MARK: - Methods
    private func setLayout() {
        [titleLabel, submitButton, signinDescriptionView, signinProfileView, signinNicknameView, signinBirthdateView].forEach {
            addSubview($0)
        }
        
        titleLabel
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor, constant: UIConstants.padding / 2)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding / 2)
        
        signinProfileView
            .centerXLayout(equalTo: centerXAnchor)
            .topLayout(equalTo: titleLabel.bottomAnchor, constant: 20)
            .widthLayout(UIScreenUtils.getScreenWidth())
            .heightLayout(140)
        
        signinDescriptionView
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor)
            .topLayout(equalTo: signinProfileView.bottomAnchor, constant: 20)
            .widthLayout(UIScreenUtils.getScreenWidth())
            .heightLayout(65)
        
        signinBirthdateView
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor)
            .topLayout(equalTo: signinDescriptionView.bottomAnchor, constant: 20)
            .widthLayout(UIScreenUtils.getScreenWidth())
            .heightLayout(65)
        
        signinNicknameView
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor)
            .topLayout(equalTo: signinBirthdateView.bottomAnchor, constant: 20)
            .widthLayout(UIScreenUtils.getScreenWidth())
            .heightLayout(65)
        
        submitButton
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor)
            .trailingLayout(equalTo: safeAreaLayoutGuide.trailingAnchor)
            .bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor)
            .heightLayout(UIConstants.submitButtonHeight)
    }
    
    private func setKeyboardObserver() {
        let keyboardAnimationManager = KeyboardAnimationManager()
        keyboardAnimationManager.setKeyboardObservers { [weak self] keyboardHeight, isKeyboardVisible in
            guard let self else { return }
            if isKeyboardVisible {
                self.submitButton.bottomLayout(equalTo: self.bottomAnchor, constant: -keyboardHeight)
                    .heightLayout(UIConstants.submitButtonHeight)
            } else {
                self.submitButton.bottomLayout(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
                    .heightLayout(UIConstants.submitButtonHeight)
            }
            self.layoutIfNeeded()
        }
    }
    
    func setSubmitButtonTitle(_ title: String) {
        submitButton.setTitle(title, for: .normal)
    }
    
    func setSubmitButton(type: InputButtonStype) {
        switch type {
        case .enabled:
            submitButton.backgroundColor = .systemBlue
            submitButton.isEnabled = true
        case .disabled:
            submitButton.isEnabled = false
            submitButton.backgroundColor = .systemGray
        }
    }
    
    func setProfileImage(_ imageInfo: ImageInfo) {
        signinProfileView.profileImage.setImage(imageInfo.image, for: .normal)
    }
    
    func setProfileImageButtonAction(_ action: UIAction) {
        signinProfileView.profileImage.addAction(action, for: .touchUpInside)
    }
    
    func setSubmitButtonAction(_ action: UIAction) {
        submitButton.addAction(action, for: .touchUpInside)
    }
}
