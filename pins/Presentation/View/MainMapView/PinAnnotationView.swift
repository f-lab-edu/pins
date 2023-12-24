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
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "PinCluster"
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
