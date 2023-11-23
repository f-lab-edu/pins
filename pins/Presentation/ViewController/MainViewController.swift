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
import FirebaseAuth

final class MainViewController: UIViewController {
    private lazy var firebaseRepository: FirebaseRepository = FirebaseRepository()
    private lazy var firestoreService: FirestorageServiceProtocol = FirestorageService(firebaseRepository: firebaseRepository)
    private lazy var mainUseCase: MainUseCaseProtocol = MainUseCase(firestorageService: firestoreService)
    private lazy var viewModel: MainViewModel = MainViewModel(mainUseCase: mainUseCase)
    
    private var mainMapView: MainMapView {
        view as! MainMapView
    }
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainMapView.setDelegate(self)
        locationManager.delegate = self
        
        setLocationManager()
        setAction()
        
        viewModel.$createViewIsPresented.sink { [weak self] isPresented in
            self?.mainMapView.presentCreateView(isPresented: isPresented)
        }.store(in: &cancellable)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPins()
    }
    
    override func loadView() {
        view = MainMapView()
    }
    
    private func loadPins() {
        Task {
            let pins = await viewModel.getPins()
            mainMapView.drawPins(pins: pins)
        }
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
            guard let position = self?.mainMapView.getCenterCoordinate() else { return }
            createViewController.setPosition(position)
            self?.navigationController?.pushViewController(createViewController, animated: true)
            
            self?.viewModel.setCreateViewIsPresented(isPresented: false)
        }))
        
        mainMapView.setLogoutButtonAction(UIAction(handler: { [weak self] _ in
            do {
                try Auth.auth().signOut()
                self?.navigationController?.viewControllers = [LoginViewController()]
            } catch let signOutError as NSError {
                os_log("Error signing out: %@", log: .ui, type: .error, signOutError)
            }
        }))
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "PinAnnotaion"
        
        if annotation is MKUserLocation {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? PinAnnotationView
        
        if annotationView == nil {
            annotationView = PinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.setPinImage()
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pinAnnotation = view.annotation as? PinAnnotation else { return }
        print(pinAnnotation.pin.content)
//        let detailViewController: DetailViewController = DetailViewController()
//        detailViewController.setPin(pinAnnotation)
//        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        moveCurrentPosition()
    }
}
