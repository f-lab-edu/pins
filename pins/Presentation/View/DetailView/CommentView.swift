//
//  CommentView.swift
//  pins
//
//  Created by 주동석 on 12/11/23.
//

import UIKit

final class CommentView: UIView {
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .test)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "웰시코기"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.accessibilityIdentifier = "nameLabel"
        return label
    }()
    
    private let personalInfo: UILabel = {
        let label = UILabel()
        label.text = "ENTJ ∙ 26세"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.accessibilityIdentifier = "personalInfo"
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.accessibilityIdentifier = "contentLabel"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "0일 전"
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.accessibilityIdentifier = "dateLabel"
        return label
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [profileImageView, nameLabel, personalInfo, contentLabel, dateLabel].forEach {
            addSubview($0)
        }
        
        profileImageView
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: topAnchor, constant: 20)
            .widthLayout(40)
            .heightLayout(40)
        
        nameLabel
            .leadingLayout(equalTo: profileImageView.trailingAnchor, constant: 8)
            .topLayout(equalTo: profileImageView.topAnchor, constant: 4)
        
        personalInfo
            .leadingLayout(equalTo: profileImageView.trailingAnchor, constant: 8)
            .topLayout(equalTo: nameLabel.bottomAnchor, constant: 2)
        
        dateLabel
            .topLayout(equalTo: topAnchor, constant: 30)
            .trailingLayout(equalTo: trailingAnchor, constant: -20)
        
        contentLabel
            .topLayout(equalTo: profileImageView.bottomAnchor, constant: 12)
            .leadingLayout(equalTo: profileImageView.trailingAnchor, constant: 8)
            .trailingLayout(equalTo: trailingAnchor, constant: 20)
    }
    
    func setCommentView(_ comment: CommentResponse) {
        nameLabel.text = comment.userName
        personalInfo.text = "\(comment.userDescription) ∙ \(comment.userAge)세"
        contentLabel.text = comment.content
        dateLabel.text = comment.createdAt
        profileImageView.image = comment.userProfile
    }
}
