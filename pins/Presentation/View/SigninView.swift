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
    enum UIConstants {
        static let submitButtonHeight: CGFloat = 50
        static let padding: CGFloat = 20
        static let inputPadding: CGFloat = 50
    }
    private let viewModel: SigninViewModel
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "만나서 반가워요!"
        label.textColor = .text
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
    let nickNameInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요."
        textField.font = .systemFont(ofSize: 16)
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        textField.isHidden = true
        return textField
    }()
    let birthDateInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ex) 000101"
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = .numberPad
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        textField.isHidden = true
        return textField
    }()
    let descriptionInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "자기소개를 입력해주세요."
        textField.font = .systemFont(ofSize: 16)
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        textField.isHidden = true
        return textField
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.isHidden = true
        return label
    }()
    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.isHidden = true
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "자기소개"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.isHidden = true
        return label
    }()
    private let profileImage: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        return button
    }()
    
    // MARK: - Lifecycle
    init(viewModel: SigninViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .background
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
        [titleLabel, birthDateInput, nickNameInput, descriptionInput, submitButton, nicknameLabel, descriptionLabel, birthDateLabel, profileImage].forEach {
            addSubview($0)
        }
        
        titleLabel
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor, constant: UIConstants.padding)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        nickNameInput
            .topLayout(equalTo: titleLabel.bottomAnchor, constant: UIConstants.inputPadding)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        birthDateInput
            .topLayout(equalTo: titleLabel.bottomAnchor, constant: UIConstants.inputPadding)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        descriptionInput
            .topLayout(equalTo: titleLabel.bottomAnchor, constant: UIConstants.inputPadding)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        submitButton
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor)
            .trailingLayout(equalTo: safeAreaLayoutGuide.trailingAnchor)
            .bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding)
            .heightLayout(UIConstants.submitButtonHeight)
        
        nicknameLabel
            .topLayout(equalTo: nickNameInput.topAnchor, constant: -20)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        birthDateLabel
            .topLayout(equalTo: birthDateInput.topAnchor, constant: -20)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        descriptionLabel
            .topLayout(equalTo: descriptionInput.topAnchor, constant: -20)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        profileImage
            .topLayout(equalTo: titleLabel.bottomAnchor, constant: UIConstants.inputPadding)
            .centerXLayout(equalTo: centerXAnchor)
            .widthLayout(100)
            .heightLayout(100)
    }
    
    private func inputNickNameLayout() {
        nickNameInput.isHidden = false
        submitButton.isHidden = false
        nicknameLabel.isHidden = false
        titleLabel.text = "만나서 반가워요! \n닉네임을 입력해주세요."
        nickNameInput.becomeFirstResponder()
    }
    
    private func inputBirthDateLayout() {
        birthDateInput.isHidden = false
        birthDateLabel.isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
        nickNameInput
            .topLayout(equalTo: birthDateInput.bottomAnchor, constant: UIConstants.inputPadding)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        titleLabel.text = "생년월일을 \n6글자로 입력해주세요."
        birthDateInput.becomeFirstResponder()
    }
    
    private func inputDescriptionLayout() {
        descriptionInput.isHidden = false
        descriptionLabel.isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
        birthDateInput
            .topLayout(equalTo: descriptionInput.bottomAnchor, constant: UIConstants.inputPadding)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        titleLabel.text = "다섯 글자로 \n자신을 소개해주세요."
        descriptionInput.becomeFirstResponder()
    }
    
    private func profileImageLayout() {
        endEditing(true)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
        profileImage.isHidden = false
        descriptionInput
            .topLayout(equalTo: profileImage.bottomAnchor, constant: UIConstants.inputPadding)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        titleLabel.text = "핀즈에서 사용하실 \n프로필을 선택해주세요."
        setSubmitButtonTitle("완료")
    }
    
    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height

                let (duration, options) = animationManager.keyboardAnimation(notification: notification)
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    self.submitButton
                        .bottomLayout(equalTo: self.bottomAnchor, constant: -keyboardHeight)
                        .heightLayout(SigninView.UIConstants.submitButtonHeight)
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            let (duration, options) = animationManager.keyboardAnimation(notification: notification)
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.submitButton
                    .bottomLayout(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
                    .heightLayout(SigninView.UIConstants.submitButtonHeight)
                self.layoutIfNeeded()
            }, completion: nil)
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
    
    func remakeLayout(step inputStep: InputStep) {
        switch inputStep {
        case .nickName:
            inputNickNameLayout()
        case .birthDate:
            inputBirthDateLayout()
        case .description:
            inputDescriptionLayout()
        case .profileImage:
            profileImageLayout()
        }
    }
    
    func setProfileImage(_ imageInfo: ImageInfo) {
        profileImage.setImage(imageInfo.image, for: .normal)
    }
    
    func setProfileImageButtonAction(_ action: UIAction) {
        profileImage.addAction(action, for: .touchUpInside)
    }
    
    func setSubmitButtonAction(_ action: UIAction) {
        submitButton.addAction(action, for: .touchUpInside)
    }
}
