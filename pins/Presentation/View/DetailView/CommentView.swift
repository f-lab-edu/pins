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
        imageView.image = .test
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.setAccessibilityIdentifier()
        return label
    }()
    
    private let personalInfo: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.setAccessibilityIdentifier()
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.setLineHeight(lineHeight: 4)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.setAccessibilityIdentifier()
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.setAccessibilityIdentifier()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sizeToFit()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: calculateDynamicHeight())
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
    
    private func calculateDynamicHeight() -> CGFloat {
        contentLabel.sizeToFit()
        let labelHeight = contentLabel.frame.height
        return labelHeight + 72
    }
    
    func setCommentView(_ comment: CommentResponse) {
        nameLabel.text = comment.userName
        personalInfo.text = "\(comment.userDescription) ∙ \(comment.userAge)세"
        contentLabel.text = comment.content
        dateLabel.text = comment.createdAt
        profileImageView.image = comment.userProfile
    }
}
