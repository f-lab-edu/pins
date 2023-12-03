//
//  SigninViewController.swift
//  pins
//
//  Created by 주동석 on 12/2/23.
//

import OSLog
import UIKit
import Combine

final class SigninViewController: UIViewController {
    private lazy var userRepository: UserRepositoryProtocol = UserRepository()
    private lazy var userService: UserServiceProtocol = UserService(userRepository: userRepository)
    private lazy var signinUsecase: SigninUseCaseProtocol = SigninUseCase(userService: userService)
    private lazy var viewModel: SigninViewModel = SigninViewModel(signinUsecase: signinUsecase)
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
        viewModel.$inputStep.sink { [weak self] step in
            self?.signinView.remakeLayout(step: step)
        }.store(in: &cancellables)
        
        viewModel.$inputButtonStyle.sink { [weak self] style in
            self?.signinView.setSubmitButton(type: style)
        }.store(in: &cancellables)
    }
    
    private func setActions() {
        signinView.setSubmitButtonAction(UIAction(handler: { [weak self] _ in
            switch self?.viewModel.inputStep {
            case .nickName:
                self?.viewModel.setInputStep(.birthDate)
            case .birthDate:
                self?.viewModel.setInputStep(.description)
            case .description:
                self?.viewModel.setNickName(self?.signinView.nickNameInput.text ?? "")
                self?.viewModel.setBirthDate(self?.signinView.birthDateInput.text ?? "")
                self?.viewModel.setDescription(self?.signinView.descriptionInput.text ?? "")
                self?.viewModel.saveUserInfo()
                let mainViewController = MainViewController()
                self?.navigationController?.pushViewController(mainViewController, animated: true)
            default:
                break
            }
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
        viewModel.setInputButtonStyle(text.count > 5 || text.count < 1 ? .disabled : .enabled)
        signinView.setSubmitButtonTitle("다음")
    }

    private func updateBirthDateInput(_ text: String) {
        viewModel.setInputButtonStyle((text.count == 6 && isValidBirthDate(dateString: text)) ? .enabled : .disabled)
        signinView.setSubmitButtonTitle("다음")
    }

    private func updateDescriptionInput(_ text: String) {
        signinView.setSubmitButtonTitle("완료")
        let nickname = signinView.nickNameInput.text ?? ""
        let birthDate = signinView.birthDateInput.text ?? ""
        if nickname.count > 5 || nickname.count < 1  || birthDate.count != 6 || !isValidBirthDate(dateString: birthDate) {
            viewModel.setInputButtonStyle(.disabled)
            return
        }
        viewModel.setInputButtonStyle(text.count > 5 || text.count < 1 ? .disabled : .enabled)
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
    private func isValidBirthDate(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        return dateFormatter.date(from: dateString) != nil
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
