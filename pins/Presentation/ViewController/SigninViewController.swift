//
//  SigninViewController.swift
//  pins
//
//  Created by 주동석 on 12/2/23.
//

import OSLog
import UIKit
import Combine
import PhotosUI

final class SigninViewController: UIViewController {
    private lazy var userRepository: UserRepositoryProtocol = UserRepository()
    private lazy var userService: UserServiceProtocol = UserService(userRepository: userRepository)
    private lazy var fireRepository: FirebaseRepositoryProtocol = FirebaseRepository()
    private lazy var firestorageService: FirestorageServiceProtocol = FirestorageService(firebaseRepository: fireRepository)
    private lazy var signinUsecase: SigninUseCaseProtocol = SigninUseCase(userService: userService, firestorageService: firestorageService)
    private lazy var viewModel: SigninViewModel = SigninViewModel(signinUsecase: signinUsecase)
    private var imagePicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }()
    private var cancellables: Set<AnyCancellable> = []
    private var signinView: SigninView {
        view as! SigninView
    }
    
    override func loadView() {
        view = SigninView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActions()
        signinView.birthDateInput.delegate = self
        signinView.nickNameInput.delegate = self
        signinView.descriptionInput.delegate = self
        imagePicker.delegate = self
        viewModel.$inputStep.sink { [weak self] step in
            self?.signinView.remakeLayout(step: step)
        }.store(in: &cancellables)
        
        viewModel.$inputButtonStyle.sink { [weak self] style in
            self?.signinView.setSubmitButton(type: style)
        }.store(in: &cancellables)
        
        viewModel.$profileImage.sink { [weak self] imageInfo in
            self?.signinView.setProfileImage(imageInfo)
        }.store(in: &cancellables)
    }
    
    private func setActions() {
        signinView.setSubmitButtonAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            switch self.viewModel.inputStep {
            case .nickName:
                self.viewModel.setInputStep(.birthDate)
            case .birthDate:
                self.viewModel.setInputStep(.description)
            case .description:
                self.viewModel.setInputStep(.profileImage)
                let validAll = self.isValidAll()
                self.updateInputState(isValid: validAll)
            case .profileImage:
                self.viewModel.setNickName(self.signinView.nickNameInput.text ?? "")
                self.viewModel.setBirthDate(self.signinView.birthDateInput.text ?? "")
                self.viewModel.setDescription(self.signinView.descriptionInput.text ?? "")
                Task {
                    try await self.viewModel.saveUserInfo()
                    let mainViewController = MainViewController()
                    self.navigationController?.pushViewController(mainViewController, animated: true)
                }
            }
        }))
        signinView.setProfileImageButtonAction(UIAction(handler: { [weak self] _ in
            guard let imagePicker = self?.imagePicker else { return }
            self?.present(imagePicker, animated: true, completion: nil)
        }))
    }
    
    private func updateInputBasedOnTextField(_ textField: UITextField, with updatedText: String) {
        if textField == signinView.nickNameInput {
            updateNicknameInput(updatedText)
        } else if textField == signinView.birthDateInput {
            updateBirthDateInput(updatedText)
        } else if textField == signinView.descriptionInput {
            updateDescriptionInput(updatedText)
        }
    }
    
    private func updateNicknameInput(_ text: String) {
        let isNicknameValid = isValidNickname(nickname: text)
        updateInputState(isValid: isNicknameValid)
        signinView.setSubmitButtonTitle("다음")
    }

    private func updateBirthDateInput(_ text: String) {
        let isBirthDateValid = isValidBirthDate(dateString: text)
        updateInputState(isValid: isBirthDateValid)
        signinView.setSubmitButtonTitle("다음")

    }

    private func updateDescriptionInput(_ text: String) {
        let isDescriptionValid = isValidDescription(description: text)
        updateInputState(isValid: isDescriptionValid)
        signinView.setSubmitButtonTitle("다음")
    }
    
    private func isValidAll() -> Bool {
        let nickName = signinView.nickNameInput.text ?? ""
        let birthDate = signinView.birthDateInput.text ?? ""
        let description = signinView.descriptionInput.text ?? ""
        return isValidNickname(nickname: nickName) && isValidBirthDate(dateString: birthDate) && isValidDescription(description: description)
    }
    
    private func isValidBirthDate(dateString: String) -> Bool {
        String.dateFormatter.dateFormat = "yyMMdd"
        return String.dateFormatter.date(from: dateString) != nil && dateString.count == 6
    }
    
    private func isValidNickname(nickname: String) -> Bool {
        return nickname.count <= 5 && nickname.count >= 1
    }
    
    private func isValidDescription(description: String) -> Bool {
        return description.count <= 5 && description.count >= 1
    }

    private func updateInputState(isValid: Bool) {
        viewModel.setInputButtonStyle(isValid ? .enabled : .disabled)
    }
    
    private func updateButtonState(for textField: UITextField) {
        let text = textField.text ?? ""
        switch textField {
        case signinView.nickNameInput:
            updateNicknameInput(text)
        case signinView.birthDateInput:
            updateBirthDateInput(text)
        case signinView.descriptionInput:
            updateDescriptionInput(text)
        default:
            break
        }
    }
    
    private func processPickerResult(_ index: Int, _ result: PHPickerResult) {
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            Task {
                let image = await ImagePickerManager.loadImageAsync(result.itemProvider)
                let extensionType = await ImagePickerManager.loadFileExtension(result.itemProvider)
                if let image = image, let extensionType = extensionType {
                    await MainActor.run {
                        viewModel.setProfileImage(image, type: extensionType)
                    }
                }
            }
        }
    }
}

extension SigninViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemBlue, thickness: 1)
        
        if textField == signinView.nickNameInput {
            viewModel.setInputStep(.nickName)
        } else if textField == signinView.birthDateInput {
            viewModel.setInputStep(.birthDate)
        } else if textField == signinView.descriptionInput {
            viewModel.setInputStep(.description)
        }
        updateButtonState(for: textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - 40, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        updateButtonState(for: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        updateInputBasedOnTextField(textField, with: updatedText)
        return true
    }
}

extension SigninViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let result = results.first else { return }
        processPickerResult(0, result)
    }
}
