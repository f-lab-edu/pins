//
//  CategoryCell.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private var categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = UIColor(resource: .extraLightGray)
        contentView.layer.cornerRadius = 17.5
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    // MARK: - Layouts
    private func setLayout() {
        contentView.addSubview(categoryLabel)
        categoryLabel
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: topAnchor)
            .bottomLayout(equalTo: bottomAnchor)
    }
    
    // MARK: - Methods
    func isSelect() {
        contentView.backgroundColor = .systemBlue
        categoryLabel.textColor = .white
    }
    
    func isUnSelect() {
        contentView.backgroundColor = UIColor(resource: .extraLightGray)
        categoryLabel.textColor = .gray
    }
    
    func setText(_ text: String) {
        categoryLabel.text = text
    }
}