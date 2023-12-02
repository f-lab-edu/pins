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
    private enum UIConstants {
        static let submitButtonHeight: CGFloat = 50
        static let padding: CGFloat = 20
    }
    private let viewModel: SigninViewModel
    private let animationManager: AnimationManager = AnimationManager()
    private var cancellables: Set<AnyCancellable> = []
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("확인", for: .normal)
        return button
    }()
    private let nickNameInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요."
        textField.font = .systemFont(ofSize: 16)
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        return textField
    }()
    private let birthDateInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ex) 000101"
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = .numberPad
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        return textField
    }()
    private let descriptionInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "자기소개를 입력해주세요."
        textField.font = .systemFont(ofSize: 16)
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        return textField
    }()
    
    // MARK: - Lifecycle
    init(viewModel: SigninViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .background
        setLayout()
        setKeyboardObserver()
        birthDateInput.delegate = self
        nickNameInput.delegate = self
        descriptionInput.delegate = self
        viewModel.$inputStep.sink { [weak self] step in
            self?.remakeLayout(step: step)
        }.store(in: &cancellables)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    // MARK: - Methods
    private func setLayout() {
        [descriptionLabel, birthDateInput, nickNameInput, descriptionInput, submitButton].forEach {
            addSubview($0)
        }
        
        descriptionLabel
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor, constant: UIConstants.padding)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        nickNameInput
            .topLayout(equalTo: descriptionLabel.bottomAnchor, constant: 40)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        birthDateInput
            .topLayout(equalTo: descriptionLabel.bottomAnchor, constant: 40)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        descriptionInput
            .topLayout(equalTo: descriptionLabel.bottomAnchor, constant: 40)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        
        submitButton
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor)
            .trailingLayout(equalTo: safeAreaLayoutGuide.trailingAnchor)
            .bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding)
            .heightLayout(UIConstants.submitButtonHeight)
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
                        .heightLayout(UIConstants.submitButtonHeight)
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
                    .heightLayout(UIConstants.submitButtonHeight)
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func remakeLayout(step inputStep: InputStep) {
        viewModel.setInputStep(inputStep)
        switch inputStep {
        case .nickName:
            inputNickNameLayout()
        case .birthDate:
            inputBirthDateLayout()
        case .description:
            inputDescriptionLayout()
        }
    }
    
    private func inputNickNameLayout() {
        descriptionLabel.text = "만나서 반가워요! \n닉네임을 입력해주세요."
        descriptionLabel.setLineHeight(lineHeight: 10)
        birthDateInput.isHidden = true
        descriptionInput.isHidden = true
        nickNameInput.isHidden = false
        
        nickNameInput
            .topLayout(equalTo: descriptionLabel.bottomAnchor, constant: 40)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
    }
    
    private func inputBirthDateLayout() {
        nickNameInput
            .topLayout(equalTo: birthDateInput.bottomAnchor, constant: 40)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        birthDateInput.isHidden = false
        submitButton.isHidden = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
        descriptionLabel.text = "생년월일을 \n6글자로 입력해주세요."
        birthDateInput.becomeFirstResponder()
    }
    
    private func inputDescriptionLayout() {
        birthDateInput
            .topLayout(equalTo: descriptionInput.bottomAnchor, constant: 40)
            .leadingLayout(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.padding)
        descriptionInput.isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
        submitButton.isHidden = false
        descriptionLabel.text = "다섯 글자로 \n자신을 소개해주세요."
        descriptionInput.becomeFirstResponder()
    }
    
    func setSubmitButtonAction(_ action: UIAction) {
        submitButton.addAction(action, for: .touchUpInside)
    }
}

extension SigninView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemBlue, thickness: 1)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == birthDateInput {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if updatedText.count == 6 {
                if isValidBirthDate(dateString: updatedText) {
                    birthDateInput.text = updatedText
                    remakeLayout(step: .description)
                } else {
                    os_log("invalid birth date", log: .ui, type: .error)
                }
            }
            return updatedText.count <= 6
        }
        return true
    }

    func isValidBirthDate(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        return dateFormatter.date(from: dateString) != nil
    }
}
