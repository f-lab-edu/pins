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
        signinView.signinBirthdateView.input.delegate = self
        signinView.signinNicknameView.input.delegate = self
        signinView.signinDescriptionView.input.delegate = self
        imagePicker.delegate = self
        
        viewModel.$inputButtonStyle.sink { [weak self] style in
            self?.signinView.setSubmitButton(type: style)
        }.store(in: &cancellables)
        
        viewModel.$profileImage.sink { [weak self] imageInfo in
            guard let imageInfo = imageInfo else { return }
            self?.checkAndUpdateInputState()
            self?.signinView.signinProfileView.setValidateText("")
            self?.signinView.setProfileImage(imageInfo)
        }.store(in: &cancellables)
    }
    
    private func setActions() {
        signinView.setSubmitButtonAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            guard isValidAll() else { return }
            self.viewModel.setNickName(self.signinView.signinNicknameView.input.text ?? "")
            self.viewModel.setBirthDate(self.signinView.signinBirthdateView.input.text ?? "")
            self.viewModel.setDescription(self.signinView.signinDescriptionView.input.text ?? "")
            Task {
                try await self.viewModel.saveUserInfo()
                let mainViewController = MainViewController()
                self.navigationController?.pushViewController(mainViewController, animated: true)
            }
        }))
        signinView.setProfileImageButtonAction(UIAction(handler: { [weak self] _ in
            guard let imagePicker = self?.imagePicker else { return }
            self?.present(imagePicker, animated: true, completion: nil)
        }))
    }
    
    private func isValidAll() -> Bool {
        let nickName = signinView.signinNicknameView.input.text ?? ""
        let birthDate = signinView.signinBirthdateView.input.text ?? ""
        let description = signinView.signinDescriptionView.input.text ?? ""
        do {
            try validateNickname(nickname: nickName)
            try validateBirthDate(dateString: birthDate)
            try validateDescription(description: description)
            return true
        } catch {
            return false
        }
    }
    
    private func validateBirthDate(dateString: String) throws {
        String.dateFormatter.dateFormat = "yyMMdd"
        guard dateString.count == 6 else {
            throw ValidationErrors.invalidBirthDateLength
        }
        guard String.dateFormatter.date(from: dateString) != nil else {
            throw ValidationErrors.invalidBirthDateFormat
        }
    }

    private func validateNickname(nickname: String) throws {
        guard nickname.count <= 6 && nickname.count >= 1 else {
            throw ValidationErrors.invalidNicknameLength
        }
    }

    private func validateDescription(description: String) throws {
        guard description.count <= 6 && description.count >= 1 else {
            throw ValidationErrors.invalidDescriptionLength
        }
    }
    
    private func checkAndUpdateInputState() {
        let isAllValid = isValidAll() && viewModel.profileImage != nil
        updateInputState(isValid: isAllValid)
    }
    
    private func updateInputState(isValid: Bool) {
        viewModel.setInputButtonStyle(isValid ? .enabled : .disabled)
    }
    
    private func processPickerResult(_ index: Int, _ result: PHPickerResult) {
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            Task {
                let image = await ImagePickerManager.loadImageAsync(result.itemProvider)
                let extensionType = await ImagePickerManager.loadFileExtension(result.itemProvider)
                if let image = image, let extensionType = extensionType {
                    await MainActor.run {
                        viewModel.setProfileImage(image, type: extensionType)
                        checkAndUpdateInputState()
                    }
                }
            }
        }
    }
}

extension SigninViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - UIConstants.padding, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemBlue, thickness: 1)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - UIConstants.padding, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == signinView.signinNicknameView.input {
            do {
                try validateNickname(nickname: textField.text ?? "")
                signinView.signinNicknameView.setValidateText("")
            } catch {
                signinView.signinNicknameView.setValidateText("1~6 글자를 입력해야 합니다.")
            }
        } else if textField == signinView.signinBirthdateView.input {
            do {
                try validateBirthDate(dateString: textField.text ?? "")
                signinView.signinBirthdateView.setValidateText("")
            } catch ValidationErrors.invalidBirthDateLength {
                signinView.signinBirthdateView.setValidateText("생년월일을 6글자로 입력해야 합니다. ex) 990101")
            } catch {
                signinView.signinBirthdateView.setValidateText("올바른 날짜 형식이 아닙니다.")
            }
        } else if textField == signinView.signinDescriptionView.input {
            do {
                try validateDescription(description: textField.text ?? "")
                signinView.signinDescriptionView.setValidateText("")
            } catch {
                signinView.signinDescriptionView.setValidateText("1~6 글자를 입력해야 합니다.")
            }
        }
        checkAndUpdateInputState()
    }
}

extension SigninViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let result = results.first else { return }
        processPickerResult(0, result)
    }
}
