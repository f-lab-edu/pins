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
    private let searchButton: CustomButton = CustomButton()
    private let createModeButton: CustomButton = CustomButton()
    private let refeshButton: CustomButton = CustomButton()
    private let myLocationButton: CustomButton = CustomButton()
    private let cancelButton: CustomButton = CustomButton()
    private let createButton: CustomButton = CustomButton()
    private let centerPinImage: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setAction()
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
        
        addSubview(centerPinImage)
        centerPinImage.isHidden = true
        centerPinImage.translatesAutoresizingMaskIntoConstraints = false
        centerPinImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        centerPinImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        centerPinImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        centerPinImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        centerPinImage.image = UIImage(systemName: "mappin")
        centerPinImage.tintColor = .systemBlue
        
        addSubview(createButton)
        createButton.isHidden = true
        createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        createButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createButton.setShadow()
        createButton.setTitle(title: "이 위치에 핀 만들기", color: .black)
        
        addSubview(cancelButton)
        cancelButton.isHidden = true
        cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        cancelButton.setSize()
        cancelButton.setShadow()
        cancelButton.setImage(systemName: "xmark")
        
        addSubview(searchButton)
        searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        searchButton.setSize()
        searchButton.setShadow()
        searchButton.setImage(systemName: "magnifyingglass")
        
        addSubview(createModeButton)
        createModeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        createModeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        createModeButton.setSize(width: 45, height: 45)
        createModeButton.setShadow()
        createModeButton.setImage(systemName: "plus")
        
        addSubview(refeshButton)
        refeshButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        refeshButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        refeshButton.setSize()
        refeshButton.setShadow()
        refeshButton.setImage(systemName: "arrow.clockwise")
        
        addSubview(myLocationButton)
        myLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        myLocationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        myLocationButton.setSize()
        myLocationButton.setShadow()
        myLocationButton.setImage(systemName: "location")
    }
    
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
}
