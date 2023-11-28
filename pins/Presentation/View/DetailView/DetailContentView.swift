//
//  DetailContentView.swift
//  pins
//
//  Created by 주동석 on 11/24/23.
//

import UIKit

final class DetailContentView: UIView {
    // MARK: - Properties
    private let bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UIImage.self, forCellWithReuseIdentifier: "ImageBanner")
        return collectionView
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .test)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
        return label
    }()
    
    private let personalInfo: UILabel = {
        let label = UILabel()
        label.text = "ENTJ ∙ 26세"
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private let categoryLabel: PaddingLabel = {
        let label = PaddingLabel(topInset: 4, bottomInset: 4, leftInset: 8, rightInset: 8)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.backgroundColor = .systemBlue
        label.setCornerRadius(offset: 12)
        label.textColor = .white
        return label
    }()
    
    private let imageCountLabel: PaddingLabel = {
        let label = PaddingLabel(topInset: 4, bottomInset: 4, leftInset: 8, rightInset: 8)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.textColor = .white
        label.setCornerRadius(offset: 12)
        label.text = "1/2"
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "0일 전"
        label.font = .systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.setLineHeight(lineHeight: 4)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글 0개"
        label.font = .systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    private let navigationDivderView: Divider = Divider()
    private let contentDivederView: Divider = Divider()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI
    private func setLayout() {
        [mainImageView, profileImageView, nameLabel, personalInfo, categoryLabel, titleLabel, dateLabel, contentLabel, commentLabel, navigationDivderView, contentDivederView, imageCountLabel].forEach {
            addSubview($0)
        }
        
        mainImageView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: topAnchor)
            .heightLayout(300)
        
        imageCountLabel
            .topLayout(equalTo: topAnchor, constant: 265)
            .trailingLayout(equalTo: trailingAnchor, constant: -15)
        
        profileImageView
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: mainImageView.bottomAnchor, constant: 16)
            .widthLayout(40)
            .heightLayout(40)
        
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
            .trailingLayout(equalTo: trailingAnchor, constant: -20)
            .topLayout(equalTo: navigationDivderView.bottomAnchor, constant: 20)
        
        dateLabel
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: titleLabel.bottomAnchor, constant: 10)
        
        contentLabel
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .trailingLayout(equalTo: trailingAnchor, constant: -20)
            .topLayout(equalTo: dateLabel.bottomAnchor, constant: 12)
        
        commentLabel
            .leadingLayout(equalTo: leadingAnchor, constant: 20)
            .topLayout(equalTo: contentLabel.bottomAnchor, constant: 20)
        
        contentDivederView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: commentLabel.bottomAnchor, constant: 16)
    }
    
    // MARK: - Methods
    func updateMainImageHeight(_ offset: CGFloat, scrollView: UIScrollView, topAnchor: NSLayoutYAxisAnchor) {
        if offset < 0 {
            mainImageView.heightLayout(300 - offset)
            mainImageView.topLayout(equalTo: topAnchor)
        } else {
            mainImageView.topLayout(equalTo: scrollView.topAnchor)
        }
    }
    
    func setPinContent(title: String, content: String, date: String, image: UIImage?, category: String) {
        titleLabel.text = title
        contentLabel.text = content
        dateLabel.text = date.convertDaysAgo()
        mainImageView.image = image
        categoryLabel.text = NSLocalizedString(category, comment: "")
    }
    
    func setLayoutDependingOnImage(isImage: Bool) {
        if !isImage {
            mainImageView.isHidden = true
            mainImageView.heightLayout(0)
            imageCountLabel.isHidden = true
        }
    }
}
