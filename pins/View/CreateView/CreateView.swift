//
//  CreateView.swift
//  pins
//
//  Created by 주동석 on 2023/10/24.
//

import UIKit

class CreateView: UIView {
    // MARK: - 프로퍼티
    private enum Constants {
        static let categoryColumn: Int = 3
        static let interGap: CGFloat = 12
        static let categoryPadding: CGFloat = 16
        static let lineGap: CGFloat = 12
        static let itemHeight: CGFloat = 35
    }
    
    private let placeholderColor = UIColor(resource: .placeholderGray)
    private let itemCount: Int
    private let titleDivider = Divider()
    private let contentDivider = Divider()
    private let imageDivider = Divider()
    var titleTextView = UITextView()
    var contentTextView = UITextView()
    
    private let imageButton: CustomButton = {
        let button = CustomButton(cornerRadius: 10)
        button.setImageTitle(title: "0/5", systemName: "photo.badge.plus", titleColor: .gray, imageColor: .gray)
        button.setBorder(width: 1, color: UIColor.lightGray.withAlphaComponent(0.5).cgColor)
        button.setSize(width: 60, height: 60)
        return button
    }()
    
    private let createButton: CustomButton = {
        let button = CustomButton()
        button.setTitle(title: "핀 만들기", color: .white)
        button.backgroundColor = .systemBlue
        button.setShadow()
        return button
    }()
    
    private let backButton: CustomButton = {
        let button = CustomButton()
        button.setImage(systemName: "chevron.backward")
        return button
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
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
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 0
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constants.interGap
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = 1
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - 생성자
    init(categoryCount: Int) {
        itemCount = categoryCount
        super.init(frame: .zero)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    // MARK: - 메소드
    private func createTextView(text: String, tag: Int) -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = text
        textView.textColor = placeholderColor
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .white
        textView.tag = tag
        return textView
    }
    
    private func setupViews() {
        titleTextView = createTextView(text: "제목을 입력해주세요.", tag: 1)
        contentTextView = createTextView(text: "내용을 입력해주세요.", tag: 2)
        
        titleTextView.delegate = self
        contentTextView.delegate = self
        
        [backButton, categoryLabel, categoryCollectionView, titleDivider, titleTextView, contentDivider, contentTextView, createButton, imageDivider, imageButton, imageCollectionView].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.setSize(width: 30, height: 30)
        
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        
        categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.categoryPadding).isActive = true
        categoryCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.categoryPadding).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalToConstant: getCagetoryHeight()).isActive = true
        
        titleDivider.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor).isActive = true
        titleDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        titleDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        titleTextView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 5).isActive = true
        titleTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentDivider.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10).isActive = true
        contentDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        contentDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        contentTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        contentTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        contentTextView.topAnchor.constraint(equalTo: contentDivider.bottomAnchor, constant: 5).isActive = true
        contentTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        createButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageDivider.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 10).isActive = true
        imageDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        imageDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        imageButton.topAnchor.constraint(equalTo: imageDivider.topAnchor, constant: 20).isActive = true
        imageButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        imageCollectionView.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 12).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        imageCollectionView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageCollectionView.topAnchor.constraint(equalTo: imageDivider.topAnchor, constant: 20).isActive = true
    }
    
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
    
    func configureCategoryCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        categoryCollectionView.delegate = delegate
        categoryCollectionView.dataSource = dataSource
        
        imageCollectionView.delegate = delegate
        imageCollectionView.dataSource = dataSource
    }
    
    func reloadImageCollectionView() {
        imageCollectionView.reloadData()
    }
    
    func setPhotoCount(count: Int) {
        imageButton.setTitle(title: "\(count)/5", color: .gray)
    }
}

// MARK: - 익스텐션
extension CreateView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            switch textView.tag {
            case 1:
                textView.text = "제목을 입력해주세요."
            case 2:
                textView.text = "내용을 입력해주세요."
            default:
                return
            }
            textView.textColor = placeholderColor
        }
    }
}
