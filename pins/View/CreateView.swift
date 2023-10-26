//
//  CreateView.swift
//  pins
//
//  Created by 주동석 on 2023/10/24.
//

import UIKit

class CreateView: UIView {
    private let itemCount: Int = 10
    private let categoryColumn: Int = 3
    private let interGap: CGFloat = 12
    private let categoryPadding: CGFloat = 16
    private let lineGap: CGFloat = 12
    
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
        let paddingSum: Int = Int(categoryPadding) * 2
        let interGapSum: Int = Int(interGap) * (categoryColumn - 1)
        let itemWidth = ((Int(screenWidth) - paddingSum - interGapSum) / categoryColumn)
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = lineGap
        layout.minimumInteritemSpacing = interGap
        layout.itemSize = CGSize(width: itemWidth, height: 40)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setLayout()
        setCategoryCollectionViewDelegate()
        registerCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    private func setLayout() {
        addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.setSize(width: 30, height: 30)
        
        addSubview(categoryLabel)
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        
        addSubview(categoryCollectionView)
        categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: categoryPadding).isActive = true
        categoryCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -categoryPadding).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalToConstant: getCagetoryHeight()).isActive = true
    }
    
    private func getCagetoryHeight() -> CGFloat {
        let maxRowCount = itemCount % 3 > 0 ? itemCount / 3 + 1 : itemCount / 3
        return CGFloat(maxRowCount * 40 + Int(lineGap) * categoryColumn)
    }
    
    func setBackButtonAction(_ action: UIAction) {
        backButton.addAction(action, for: .touchUpInside)
    }
    
    func setCategoryCollectionViewDelegate() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    func registerCollectionView() {
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
    }
}

extension CreateView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        return cell
    }
}
