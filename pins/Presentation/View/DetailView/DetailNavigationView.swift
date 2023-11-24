//
//  DetailNavigationView.swift
//  pins
//
//  Created by 주동석 on 11/24/23.
//

import UIKit

final class DetailNavigationView: UIView {
    // MARK: - Properties
    private let backButton: CustomButton = {
        let button = CustomButton(backgroundColor: .clear, tintColor: .white)
        button.setImage(systemName: "chevron.backward")
        return button
    }()
    
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI
    private func setLayout() {
        [backButton].forEach {
            addSubview($0)
        }
        
        backButton
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor)
            .widthLayout(30)
            .heightLayout(30)
    }
}
