//
//  ViewController.swift
//  pins
//
//  Created by 주동석 on 2023/10/19.
//

import UIKit
import OSLog
import MapKit
import Combine

class MainViewController: UIViewController {
    let viewModel: MainViewModel = MainViewModel()
    
    var mainMapView: MainMapView {
        view as! MainMapView
    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainMapView.setDelegate(self)
        locationManager.delegate = self
        
        setLocationManager()
        setAction()
        
        viewModel.$createViewIsPresented.sink { [weak self] IsPresented in
            self?.mainMapView.presentCreateView(isPresented: IsPresented)
        }.store(in: &cancellable)
    }
    
    override func loadView() {
        view = MainMapView()
    }
    
    private func setLocationManager() {
        let authorizationStatus: CLAuthorizationStatus
        
        authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // 위치 서비스를 사용할 수 없을 때 설정 창으로 이동하는 얼럿창 띄우기
            os_log("위치 서비스를 사용할 수 없습니다.", log: OSLog.ui, type: .info)
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
    
    private func moveCurrentPosition() {
        guard let location = locationManager.location else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mainMapView.setRegion(region, animated: true)
    }
    
    private func setAction() {
        mainMapView.setMylocationButtonAction(UIAction(handler: { [weak self] _ in
            self?.moveCurrentPosition()
        }))
        
        mainMapView.setSearchButtonAction(UIAction(handler: { [weak self] _ in
            let searchViewController: SearchViewController = SearchViewController()
            self?.navigationController?.pushViewController(searchViewController, animated: true)
        }))
        
        mainMapView.setCreateModeButtonAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.setCreateViewIsPresented(isPresented: true)
        }))
        
        mainMapView.setCreateButtonAction(UIAction(handler: { [weak self] _ in
            let createViewController: CreateViewController = CreateViewController()
            self?.navigationController?.pushViewController(createViewController, animated: true)
            
            self?.viewModel.setCreateViewIsPresented(isPresented: false)
        }))
    }
}

extension MainViewController: MKMapViewDelegate {
    
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        moveCurrentPosition()
    }
}
