//
//  MainMapView.swift
//  pins
//
//  Created by 주동석 on 10/22/23.
//

import UIKit
import MapKit

class MainMapView: UIView {
    let mapView: MKMapView = MKMapView()
    let searchButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLayout() {
        addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.preferredConfiguration = MKStandardMapConfiguration()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(searchButton)
        searchButton.tintColor = .black
        searchButton.backgroundColor = .white
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        setButtonStyle(button: searchButton, systemName: "magnifyingglass")
        
    }
    
    private func setButtonStyle(button: UIButton, systemName: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .medium)
        
        button.setImage(UIImage(systemName: systemName, withConfiguration: largeConfig), for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.2
    }
}
