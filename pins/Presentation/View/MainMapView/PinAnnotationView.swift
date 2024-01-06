//
//  PinAnnotationView.swift
//  pins
//
//  Created by 주동석 on 11/23/23.
//

import UIKit
import MapKit

final class PinAnnotationView: MKAnnotationView, AnnotationIdentifying {
    private var pinImageView: UIImageView = UIImageView()
    
    override var annotation: MKAnnotation? {
        didSet {
            guard annotation is PinAnnotation else { return }
            clusteringIdentifier = "PinCluster"
            setLayout()
            setPinImage()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pinImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = CGSize(width: 40, height: 55)
        frame.size = imageSize
        centerOffset = CGPoint(x: 0, y: -imageSize.height / 2)
    }
    
    private func setLayout() {
        addSubview(pinImageView)
        pinImageView
            .heightLayout(55)
            .widthLayout(40)
            .centerXLayout(equalTo: centerXAnchor)
            .bottomLayout(equalTo: bottomAnchor)
    }
    
    func setPinImage() {
        guard let annotation = annotation as? PinAnnotation else { return }
        pinImageView.image = UIImage(named: annotation.imageName)
    }
}
