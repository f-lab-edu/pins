//
//  DetailContentView.swift
//  pins
//
//  Created by 주동석 on 11/24/23.
//

import UIKit

final class DetailContentView: UIView {
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
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.accessibilityIdentifier = "nameLabel"
        return label
    }()
    
    private let personalInfo: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.accessibilityIdentifier = "personalInfo"
        return label
    }()
    
    private let categoryLabel: PaddingLabel = {
        let label = PaddingLabel(inset: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.backgroundColor = .systemBlue
        label.setCornerRadius(offset: 12)
        label.textColor = .white
        label.accessibilityIdentifier = "categoryLabel"
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.accessibilityIdentifier = "titleLabel"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.accessibilityIdentifier = "dateLabel"
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.setLineHeight(lineHeight: 4)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.accessibilityIdentifier = "contentLabel"
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.accessibilityIdentifier = "commentLabel"
        return label
    }()
    
    var commentContainer: UIView = UIView()
    private var commentViews: [CommentView] = []
    private let navigationDivderView: Divider = Divider()
    private let contentDividerView: Divider = Divider()
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        setLayout()
        setupAcceesibilityLabel()
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
    
    private func calculateDynamicHeight() -> CGFloat {
        contentLabel.sizeToFit()
        let labelHeight = contentLabel.frame.height
        return labelHeight + 215
    }
    
    // MARK: - UI
    private func setLayout() {
        [profileImageView, nameLabel, personalInfo, categoryLabel, titleLabel, dateLabel, contentLabel, commentLabel, navigationDivderView, contentDividerView, commentContainer].forEach {
            addSubview($0)
        }
        
        profileImageView
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: topAnchor, constant: 20)
            .heightLayout(40)
            .widthLayout(40)
        
        nameLabel
            .leadingLayout(equalTo: profileImageView.trailingAnchor, constant: 8)
            .topLayout(equalTo: profileImageView.topAnchor, constant: 4)
        
        personalInfo
            .leadingLayout(equalTo: profileImageView.trailingAnchor, constant: 8)
            .topLayout(equalTo: nameLabel.bottomAnchor, constant: 2)

        categoryLabel
            .trailingLayout(equalTo: trailingAnchor, constant: -20)
            .centerYLayout(equalTo: profileImageView.centerYAnchor)
        
        navigationDivderView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: profileImageView.bottomAnchor, constant: 16)
        
        titleLabel
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: navigationDivderView.bottomAnchor, constant: 20)
        
        dateLabel
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: titleLabel.bottomAnchor, constant: 10)
        
        contentLabel
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: dateLabel.bottomAnchor, constant: 12)
        
        commentLabel
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: contentLabel.bottomAnchor, constant: 20)
        
        contentDividerView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: commentLabel.bottomAnchor, constant: 16)
        
        commentContainer
           .topLayout(equalTo: contentDividerView.bottomAnchor)
           .leadingLayout(equalTo: leadingAnchor)
           .trailingLayout(equalTo: trailingAnchor)
    }
    
    private func setupAcceesibilityLabel() {
        var elements = [Any]()
        
        elements.append(nameLabel)
        elements.append(personalInfo)
        elements.append(categoryLabel)
        elements.append(titleLabel)
        elements.append(dateLabel)
        elements.append(contentLabel)
        elements.append(commentLabel)
        
        accessibilityElements = elements
    }
    
    // MARK: - Methods
    func setPinContent(pin: PinResponse) {
        titleLabel.text = pin.title
        contentLabel.text = pin.content
        dateLabel.text = pin.created.convertDaysAgo()
        categoryLabel.text = NSLocalizedString(pin.category, comment: "")
        nameLabel.text = pin.userName
        personalInfo.text = "\(pin.userDescription) ∙ \(pin.userAge)세"
        profileImageView.image = pin.userProfile
    }
    
    func setComments(comments: [CommentResponse], scrollView: UIScrollView?) {
        resetCommentContainer()
        commentLabel.text = "댓글 \(comments.count)개"
        
        for (index, comment) in comments.enumerated() {
            let commentView = CommentView()
            commentView.setCommentView(comment)
            commentViews.append(commentView)
            commentContainer.addSubview(commentView)
            
            if index == 0 {
                commentView.topLayout(equalTo: commentContainer.topAnchor)
            } else {
                commentView.topLayout(equalTo: commentViews[index - 1].bottomAnchor)
            }
            commentView.leadingLayout(equalTo: leadingAnchor)
            commentView.trailingLayout(equalTo: trailingAnchor)
            commentView.layoutIfNeeded()
            scrollView?.contentSize.height += commentView.frame.height
        }
    }
    
    func resetCommentContainer() {
        for comment in commentContainer.subviews {
            comment.removeFromSuperview()
        }
    }
}
