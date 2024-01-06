//
//  PinClusterAnnotation.swift
//  pins
//
//  Created by 주동석 on 12/18/23.
//

import MapKit

final class PinClusterAnnotationView: MKAnnotationView, AnnotationIdentifying {
    private var label: UILabel = {
        var label: UILabel = UILabel()
        label.layer.cornerRadius = 30
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override var annotation: MKAnnotation? {
        didSet {
            guard let annotation = annotation as? MKClusterAnnotation else { return }
            displayPriority = .defaultHigh
            setLayout()
            setClusterCount(count: annotation.memberAnnotations.count)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = CGSize(width: 60, height: 60)
        frame.size = imageSize
        centerOffset = CGPoint(x: 0, y: -imageSize.height / 2)
    }
    
    private func setLayout() {
        addSubview(label)
        label
            .heightLayout(60)
            .widthLayout(60)
            .centerXLayout(equalTo: centerXAnchor)
            .bottomLayout(equalTo: bottomAnchor)
    }
    
    func setClusterCount(count: Int) {
        label.text = "\(count)"
    }
}
