//
//  CategoryCell.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    var categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    private func setLayout() {
        contentView.addSubview(categoryLabel)
        contentView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        contentView.layer.cornerRadius = 17.5
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func isSelect() {
        contentView.backgroundColor = .systemBlue
        categoryLabel.textColor = .white
    }
    
    func isUnSelect() {
        contentView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        categoryLabel.textColor = .gray
    }
    
    func setText(_ text: String) {
        categoryLabel.text = text
    }
}
