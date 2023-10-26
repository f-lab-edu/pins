//
//  MainMapView.swift
//  pins
//
//  Created by 주동석 on 10/22/23.
//

import UIKit
import MapKit

class MainMapView: UIView {
    private let mapView: MKMapView = MKMapView()
    private let searchButton: UIButton = UIButton()
    private let createButton: UIButton = UIButton()
    private let refeshButton: UIButton = UIButton()
    private let myLocationButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    private func setLayout() {
        addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKStandardMapConfiguration()
        } else {
            mapView.mapType = .standard
        }
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        setButtonStyle(button: searchButton, systemName: "magnifyingglass")
        
        addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        createButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        createButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        setButtonStyle(button: createButton, systemName: "plus")
        
        addSubview(refeshButton)
        refeshButton.translatesAutoresizingMaskIntoConstraints = false
        refeshButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        refeshButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        refeshButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        refeshButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        setButtonStyle(button: refeshButton, systemName: "arrow.clockwise")
        
        addSubview(myLocationButton)
        myLocationButton.translatesAutoresizingMaskIntoConstraints = false
        myLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        myLocationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        myLocationButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        myLocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        setButtonStyle(button: myLocationButton, systemName: "location")
    }
    
    private func setButtonStyle(button: UIButton, systemName: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .medium)
        
        button.setImage(UIImage(systemName: systemName, withConfiguration: largeConfig), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.2
    }
    
    func setDelegate(_ delegate: MKMapViewDelegate) {
        mapView.delegate = delegate
    }
    
    func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: animated)
    }
    
    func setMylocationButtonAction(_ action: UIAction) {
        myLocationButton.addAction(action, for: .touchUpInside)
    }
    
    func setSearchButtonAction(_ action: UIAction) {
        searchButton.addAction(action, for: .touchUpInside)
    }
    
    func setCreateButtonAction(_ action: UIAction) {
        createButton.addAction(action, for: .touchUpInside)
    }
}
