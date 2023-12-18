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
    private lazy var userRepository: UserRepository = UserRepository()
    private lazy var userService: UserServiceProtocol = UserService(userRepository: userRepository)
    private lazy var mainUseCase: MainUseCaseProtocol = MainUseCase(firestorageService: firestoreService, userService: userService)
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
        
        viewModel.$currentPins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pins in
            self?.mainMapView.drawPins(pins: pins)
        }.store(in: &cancellable)
        
        Task {
            try await viewModel.getUserInfo()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPins()
    }
    
    override func loadView() {
        view = MainMapView()
    }
    
    private func loadPins() {
        Task {
            await viewModel.setCurrentPins()
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
    
    private func zoomCamera(position: CLLocationCoordinate2D, delta: CGFloat) {
        let currentSpan = mainMapView.getRegion().span
        let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta * delta, longitudeDelta: currentSpan.longitudeDelta * delta)
        let region = MKCoordinateRegion(center: position, span: zoomSpan)
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
            self?.mainMapView.addPinAnimations()
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
        if annotation is MKUserLocation {
            return nil
        }
        if let cluster = annotation as? MKClusterAnnotation {
            let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: PinClusterAnnotationView.identifier) as? PinClusterAnnotationView
            clusterView?.setClusterCount(count: cluster.memberAnnotations.count)
            return clusterView
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PinAnnotationView.identifier) as? PinAnnotationView
        
        if annotationView == nil {
            annotationView = PinAnnotationView(annotation: annotation, reuseIdentifier: PinAnnotationView.identifier)
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.setPinImage()
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let clusterAnnotationView = view as? PinClusterAnnotationView {
            if let clusterAnnotation = view.annotation as? MKClusterAnnotation {
                zoomCamera(position: clusterAnnotation.coordinate, delta: 0.5)
            }
        } else if let pinAnnotation = view.annotation as? PinAnnotation {
            Task {
                let pin = try await viewModel.loadPin(pin: pinAnnotation.pin)
                let detailViewController: DetailViewController = DetailViewController()
                detailViewController.setPin(pin: pin)
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        moveCurrentPosition()
    }
}
