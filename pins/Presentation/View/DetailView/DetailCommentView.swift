//
//  DetailCommentView.swift
//  pins
//
//  Created by 주동석 on 11/24/23.
//

import UIKit

final class DetailCommentView: UIView {
    // MARK: - Properties
    private let myProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .test)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let inputTextView: UITextField = {
        let textView = UITextField()
        textView.font = .systemFont(ofSize: 15, weight: .regular)
        textView.layer.cornerRadius = 20
        textView.clipsToBounds = true
        textView.backgroundColor = .systemGray6
        textView.placeholder = "댓글을 입력하세요."
        textView.addLeftPadding(10)
        return textView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let commentDivderView: Divider = Divider()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setLayout()
        setProfileImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    // MARK: - UI
    private func setLayout() {
        [inputTextView, myProfileImageView, submitButton, commentDivderView].forEach {
            addSubview($0)
        }
        
        commentDivderView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: topAnchor)
        
        myProfileImageView
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: commentDivderView.bottomAnchor, constant: 16)
            .widthLayout(40)
            .heightLayout(40)
        
        inputTextView
            .leadingLayout(equalTo: myProfileImageView.trailingAnchor, constant: 8)
            .trailingLayout(equalTo: trailingAnchor, constant: -20)
            .topLayout(equalTo: commentDivderView.bottomAnchor, constant: 16)
            .heightLayout(40)
        
        submitButton
            .trailingLayout(equalTo: trailingAnchor, constant: -30)
            .centerYLayout(equalTo: inputTextView.centerYAnchor)
    }
    
    private func setProfileImage() {
        let image = KeychainManager.loadImage(forKey: .userProfile)
        guard let image else { return }
        myProfileImageView.image = image
    }
    
    // MARK: - Methods
}
