//
//  CategoryCell.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    var button: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    private func setLayout() {
        contentView.addSubview(button)
        contentView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        contentView.layer.cornerRadius = 20
    }
    
    private func setAction() {
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.button.backgroundColor = .blue
        }), for: .touchUpInside)
    }
}
