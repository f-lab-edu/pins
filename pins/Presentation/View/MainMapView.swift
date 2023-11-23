//
//  MainMapView.swift
//  pins
//
//  Created by 주동석 on 10/22/23.
//

import UIKit
import MapKit

final class MainMapView: UIView {
    // MARK: - Properties
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKStandardMapConfiguration()
        } else {
            mapView.mapType = .standard
        }
        return mapView
    }()
    private let centerPinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage(resource: .pinsIcon)
        imageView.tintColor = .systemBlue
        imageView.layer.add(AnimationManager.shakingAnimation(), forKey: "shake")
        return imageView
    }()
    private let createButton: CustomButton = {
        let button = CustomButton()
        button.isHidden = true
        button.setShadow()
        button.setTitle(title: "이 위치에 핀 만들기", color: .black)
        return button
    }()
    private let cancelButton: CustomButton = {
        let button = CustomButton()
        button.isHidden = true
        button.setShadow()
        button.setImage(systemName: "xmark")
        return button
    }()
    private let searchButton: CustomButton = {
        let button = CustomButton()
        button.setShadow()
        button.setImage(systemName: "magnifyingglass")
        return button
    }()
    private let createModeButton: CustomButton = {
        let button = CustomButton()
        button.setShadow()
        button.setImage(systemName: "plus")
        return button
    }()
    private let refeshButton: CustomButton = {
        let button = CustomButton()
        button.setShadow()
        button.setImage(systemName: "arrow.clockwise")
        return button
    }()
    private let myLocationButton: CustomButton = {
        let button = CustomButton()
        button.setShadow()
        button.setImage(systemName: "location")
        return button
    }()
    private let logoutButton: CustomButton = {
        let button = CustomButton()
        button.setShadow()
        button.setImage(systemName: "door.right.hand.open")
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    // MARK: - Layouts
    private func setLayout() {
        [mapView, centerPinImage, createButton, cancelButton, searchButton, createModeButton, refeshButton, myLocationButton, logoutButton].forEach { addSubview($0) }
        
        mapView
            .leadingLayout(equalTo: leadingAnchor)
            .topLayout(equalTo: topAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .bottomLayout(equalTo: bottomAnchor)
        
        centerPinImage
            .centerXLayout(equalTo: centerXAnchor)
            .centerYLayout(equalTo: centerYAnchor)
            .widthLayout(35)
            .heightLayout(35)
        
        createButton
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
            .heightLayout(50)
        
        cancelButton
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
            .widthLayout(45)
            .heightLayout(45)
        
        searchButton
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
            .widthLayout(45)
            .heightLayout(45)
        
        createModeButton
            .centerXLayout(equalTo: centerXAnchor)
            .bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
            .widthLayout(50)
            .heightLayout(50)
        
        refeshButton
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
            .widthLayout(45)
            .heightLayout(45)
        
        myLocationButton
            .trailingLayout(equalTo: trailingAnchor, constant: -16)
            .bottomLayout(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
            .widthLayout(45)
            .heightLayout(45)
        
        logoutButton
            .leadingLayout(equalTo: leadingAnchor, constant: 16)
            .topLayout(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
            .widthLayout(45)
            .heightLayout(45)
    }
    
    // MARK: - Methods
    private func setAction() {
        cancelButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presentCreateView(isPresented: false)
        }), for: .touchUpInside)
    }
    
    func presentCreateView(isPresented: Bool) {
        searchButton.isHidden = isPresented
        refeshButton.isHidden = isPresented
        createModeButton.isHidden = isPresented
        myLocationButton.isHidden = isPresented
        
        cancelButton.isHidden = !isPresented
        createButton.isHidden = !isPresented
        centerPinImage.isHidden = !isPresented
    }
    
    func drawPins(pins: [Pin]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for pin in pins {
            let annotation = MKPointAnnotation()
            print("\(pin.longitude)  \(pin.latitude)")
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotation.title = pin.title
            mapView.addAnnotation(annotation)
        }
    }
    
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        return mapView.centerCoordinate
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
    
    func setCreateModeButtonAction(_ action: UIAction) {
        createModeButton.addAction(action, for: .touchUpInside)
    }
    
    func setCreateButtonAction(_ action: UIAction) {
        createButton.addAction(action, for: .touchUpInside)
    }
    
    func setLogoutButtonAction(_ action: UIAction) {
        logoutButton.addAction(action, for: .touchUpInside)
    }
}
