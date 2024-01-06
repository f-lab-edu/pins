//
//  SigninBirthdateView.swift
//  pins
//
//  Created by 주동석 on 1/6/24.
//

import UIKit

final class SigninBirthdateView: UIView {
    let birthDateInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "생년월일을 입력해주세요."
        textField.font = .systemFont(ofSize: 16)
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - UIConstants.padding, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        return textField
    }()
    
    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    private let validateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [birthDateLabel, birthDateInput, validateLabel].forEach { addSubview($0) }
        
        birthDateInput
            .topLayout(equalTo: topAnchor)
            .leadingLayout(equalTo: leadingAnchor, constant: UIConstants.padding / 2)
        
        birthDateLabel
            .bottomLayout(equalTo: birthDateInput.topAnchor, constant: -5)
            .leadingLayout(equalTo: leadingAnchor, constant: UIConstants.padding / 2)
        
        validateLabel
            .topLayout(equalTo: birthDateInput.bottomAnchor, constant: 10)
            .leadingLayout(equalTo: leadingAnchor, constant: UIConstants.padding / 2)
    }
    
    func setValidateText(_ text: String) {
        validateLabel.text = text
    }
}
