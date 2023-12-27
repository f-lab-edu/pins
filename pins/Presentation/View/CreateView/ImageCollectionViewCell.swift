//
//  ImageCollectionViewCell.swift
//  pins
//
//  Created by 주동석 on 10/29/23.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    // MARK: - Properties
    private var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    // MARK: - Layouts
    private func setLayout() {
        contentView.addSubview(imageView)
        
        contentView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: topAnchor)
            .bottomLayout(equalTo: bottomAnchor)
        
        imageView
            .widthLayout(60)
            .heightLayout(60)
    }
    
    // MARK: - Methods
    func setImage(image: UIImage) {
        imageView.image = image
    }
}
