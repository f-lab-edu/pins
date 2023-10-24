//
//  ViewController.swift
//  pins
//
//  Created by 주동석 on 2023/10/19.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    var mainMapView: MainMapView {
        view as! MainMapView
    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainMapView.mapView.delegate = self
        locationManager.delegate = self
        
        setLocationManager()
        setAction()
    }
    
    override func loadView() {
        view = MainMapView()
    }
    
    private func setLocationManager() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("거절됨")
            // 위치 서비스를 사용할 수 없을 때 설정 창으로 이동하는 얼럿창 띄우기
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
    
    private func moveCurrentPosition() {
        guard let location = locationManager.location else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mainMapView.mapView.setRegion(region, animated: true)
    }
    
    private func setAction() {
        mainMapView.setMylocationButtonAction(UIAction(handler: { [weak self] _ in
            self?.moveCurrentPosition()
        }))
        
        mainMapView.setSearchButtonAction(UIAction(handler: { [weak self] _ in
            let searchViewController: SearchViewController = SearchViewController()
            self?.navigationController?.pushViewController(searchViewController, animated: true)
        }))
    }
}

extension ViewController: MKMapViewDelegate {
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        moveCurrentPosition()
    }
}
