//
//  CategoryCell.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private var categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = UIColor(resource: .categoryGray)
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
        contentView.backgroundColor = UIColor(resource: .categoryGray)
        categoryLabel.textColor = .gray
    }
    
    func setText(_ text: String) {
        categoryLabel.text = NSLocalizedString(text, comment: "")
    }
}
