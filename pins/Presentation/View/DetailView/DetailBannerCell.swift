//
//  DetailBannerCell.swift
//  pins
//
//  Created by 주동석 on 2023/11/29.
//

import UIKit

final class DetailBannerCell: UICollectionViewCell {
    static let identifier: String = "ImageBanner"
    
    var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .test)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.transform = CGAffineTransform.identity
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(bannerImageView)
        
        contentView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: topAnchor)
            .bottomLayout(equalTo: bottomAnchor)
        
        bannerImageView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: contentView.topAnchor)
            .bottomLayout(equalTo: bottomAnchor)
    }
}
