//
//  CreateView.swift
//  pins
//
//  Created by 주동석 on 2023/10/24.
//

import UIKit

final class CreateView: UIView {
    // MARK: - Properties
    private enum Constants {
        static let categoryColumn: Int = 3
        static let interGap: CGFloat = 12
        static let categoryPadding: CGFloat = 16
        static let lineGap: CGFloat = 12
        static let itemHeight: CGFloat = 35
        static let selectionLimitCount = 3
    }
    
    private let imageButton: CustomButton = {
        let button = CustomButton(backgroundColor: .defaultBackground, cornerRadius: 10)
        button.setImageTitle(title: "0/\(Constants.selectionLimitCount)", systemName: "photo.badge.plus", titleColor: .gray, imageColor: .gray)
        button.setBorder(width: 1, color: UIColor.lightGray.withAlphaComponent(0.5).cgColor)
        return button
    }()
    
    private let createButton: CustomButton = {
        let button = CustomButton()
        button.setTitle(title: NSLocalizedString("create.pin", comment: ""), color: .white)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = .systemBlue
        button.setShadow()
        return button
    }()
    
    private let backButton: CustomButton = {
        let button = CustomButton(backgroundColor: .defaultBackground)
        button.setImage(systemName: "chevron.backward")
        return button
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("create.category.title", comment: "")
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .defaultText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let paddingSum: Int = Int(Constants.categoryPadding) * 2
        let interGapSum: Int = Int(Constants.interGap) * (Constants.categoryColumn - 1)
        let itemWidth = ((Int(screenWidth) - paddingSum - interGapSum) / Constants.categoryColumn)
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.lineGap
        layout.minimumInteritemSpacing = Constants.interGap
        layout.itemSize = CGSize(width: itemWidth, height: Int(Constants.itemHeight))
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 0
        collectionView.backgroundColor = .defaultBackground
        return collectionView
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constants.interGap
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 1
        collectionView.backgroundColor = .defaultBackground
        return collectionView
    }()

    private let itemCount: Int
    private let titleDivider = Divider()
    private let contentDivider = Divider()
    private let imageDivider = Divider()
    var titleTextView: CustomTextView = CustomTextView(placeholder: "create.title.placeholder", tag: 1)
    var contentTextView: CustomTextView = CustomTextView(placeholder: "create.content.placeholder", tag: 2)
    
    // MARK: - 생성자
    init(categoryCount: Int) {
        itemCount = categoryCount
        super.init(frame: .zero)
        backgroundColor = .defaultBackground
        titleTextView.delegate = self
        contentTextView.delegate = self
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    // // MARK: - Layouts
    private func setLayout() {
        [backButton, categoryLabel, categoryCollectionView, titleDivider, titleTextView, contentDivider, contentTextView, createButton, imageDivider, imageButton, imageCollectionView].forEach {
            addSubview($0)
        }
        backButton
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor)
            .widthLayout(30)
            .heightLayout(30)
        
        categoryLabel
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor, constant: 45)
        
        categoryCollectionView
            .leadingLayout(equalTo: leadingAnchor, constant: Constants.categoryPadding)
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80)
            .trailingLayout(equalTo: trailingAnchor, constant: -Constants.categoryPadding)
            .heightLayout(getCagetoryHeight())
        
        titleDivider
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .topLayout(equalTo: categoryCollectionView.bottomAnchor)
        
        titleTextView
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .topLayout(equalTo: titleDivider.bottomAnchor, constant: 5)
            .heightLayout(30)
        
        contentDivider
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .topLayout(equalTo: titleTextView.bottomAnchor, constant: 10)
        
        contentTextView
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .topLayout(equalTo: contentDivider.bottomAnchor, constant: 5)
            .heightLayout(200)
        
        createButton
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
            .heightLayout(50)
        
        imageDivider
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .topLayout(equalTo: contentTextView.bottomAnchor, constant: 10)
        
        imageButton
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .topLayout(equalTo: imageDivider.bottomAnchor, constant: 20)
            .widthLayout(60)
            .heightLayout(60)
        
        imageCollectionView
            .leadingLayout(equalTo: imageButton.trailingAnchor, constant: 12)
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .heightLayout(60)
            .topLayout(equalTo: imageDivider.topAnchor, constant: 20)
    }
    
    // MARK: - 메소드
    
    private func getCagetoryHeight() -> CGFloat {
        let rowsNeeded = (itemCount + Constants.categoryColumn - 1) / Constants.categoryColumn
        return CGFloat(rowsNeeded * 40 + (rowsNeeded - 1) * Int(Constants.lineGap))
    }
    
    func setBackButtonAction(_ action: UIAction) {
        backButton.addAction(action, for: .touchUpInside)
    }
    
    func setImageButtonAction(_ action: UIAction) {
        imageButton.addAction(action, for: .touchUpInside)
    }
    
    func setCreateButtonAction(_ action: UIAction) {
        createButton.addAction(action, for: .touchUpInside)
    }
    
    func configureCategoryCollectionView(handler: CategoryCollectionViewHandler) {
        categoryCollectionView.delegate = handler
        categoryCollectionView.dataSource = handler
    }
    
    func configureImageCollectionView(handler: ImageCollectionViewHandler) {
        imageCollectionView.delegate = handler
        imageCollectionView.dataSource = handler
    }
    
    func reloadImageCollectionView() {
        imageCollectionView.reloadData()
    }
    
    func setPhotoCount(count: Int) {
        imageButton.setTitle(title: "\(count)/\(Constants.selectionLimitCount)", color: .gray)
    }
}

// MARK: - Extensions
extension CreateView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderGray {
            textView.text = nil
            textView.textColor = .defaultText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            switch textView.tag {
            case 1:
                textView.text = NSLocalizedString("create.title.placeholder", comment: "")
            case 2:
                textView.text = NSLocalizedString("create.content.placeholder", comment: "")
            default:
                return
            }
            textView.textColor = .placeholderGray
        }
    }
}
