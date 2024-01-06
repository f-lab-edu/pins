//
//  SigninDescriptionView.swift
//  pins
//
//  Created by 주동석 on 1/6/24.
//

import UIKit

final class SigninDescriptionView: UIView {
    let descriptionInput: UITextField = {
        let textField = UITextField()
        textField.placeholder = "자기소개를 입력해주세요."
        textField.font = .systemFont(ofSize: 16)
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - UIConstants.padding, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "자기소개"
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
        [descriptionLabel, descriptionInput, validateLabel].forEach { addSubview($0) }
        
        descriptionInput
            .topLayout(equalTo: topAnchor)
            .leadingLayout(equalTo: leadingAnchor, constant: UIConstants.padding / 2)
        
        descriptionLabel
            .bottomLayout(equalTo: descriptionInput.topAnchor, constant: -5)
            .leadingLayout(equalTo: leadingAnchor, constant: UIConstants.padding / 2)
        
        validateLabel
            .topLayout(equalTo: descriptionInput.bottomAnchor, constant: 10)
            .leadingLayout(equalTo: leadingAnchor, constant: UIConstants.padding / 2)
    }
    
    func setValidateText(_ text: String) {
        validateLabel.text = text
    }
}
