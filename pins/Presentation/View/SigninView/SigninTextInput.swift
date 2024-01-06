//
//  SigninTextInput.swift
//  pins
//
//  Created by 주동석 on 1/6/24.
//

import UIKit

final class SigninTextInput: UIView {
    let input: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16)
        textField.frame.size = CGSize(width: UIScreenUtils.getScreenWidth() - UIConstants.padding, height: 30)
        textField.layer.addBorder(edge: .bottom, color: .systemGray, thickness: 1)
        return textField
    }()
    
    private let label: UILabel = {
        let label = UILabel()
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
    
    init(name: String, placeholder: String) {
        super.init(frame: .zero)
        setLayout()
        
        input.placeholder = placeholder
        label.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [input, label, validateLabel].forEach { addSubview($0) }
        
        input
            .topLayout(equalTo: topAnchor)
            .leadingLayout(equalTo: leadingAnchor, constant: UIConstants.padding / 2)
        
        label
            .bottomLayout(equalTo: input.topAnchor, constant: -5)
            .leadingLayout(equalTo: leadingAnchor, constant: UIConstants.padding / 2)
        
        validateLabel
            .topLayout(equalTo: input.bottomAnchor, constant: 10)
            .leadingLayout(equalTo: leadingAnchor, constant: UIConstants.padding / 2)
    }
    
    func setValidateText(_ text: String) {
        validateLabel.text = text
    }
}
