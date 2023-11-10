//
//  CreateViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import FirebaseAuth
import UIKit
import CoreLocation
import FirebaseStorage
import OSLog

class CreateViewModel {
    @Published var selectedImages: [UIImage] = []
    @Published var title: String = "제목을 입력해주세요."
    @Published var content: String = "내용을 입력해주세요."
    private var longitude: Double = 0
    private var latitude: Double = 0
    private var category: String = ""
    let pinRepository: PinRepository = PinRepository()
    var selectedCategoryIndex: Int?
    let categories: [String] = [
        "친목",
        "산책",
        "게임",
        "운동",
        "스터디",
        "아파트/이웃",
        "맛집탐방",
        "문화생활",
        "기타",
    ]
    
    func getCategoriesCount() -> Int {
        categories.count
    }
    
    func didSelectCategory(at index: Int, previouslySelected: Int?) -> (selected: Int, unselected: Int?) {
        selectedCategoryIndex = index
        category = categories[index]
        return (index, previouslySelected)
    }
    
    func getSelectedImagesCount() -> Int {
        selectedImages.count
    }
    
    func addSelectedImage(_ image: UIImage) {
        selectedImages.append(image)
    }

    func resetSelectedImages() {
        selectedImages.removeAll()
    }
    
    func setPosition(position: CLLocation) {
        self.longitude = position.coordinate.longitude
        self.latitude = position.coordinate.latitude
    }
    
    func getPosition() -> CLLocation {
        CLLocation(latitude: longitude, longitude: latitude)
    }
    
    func createPin() {
        // image upload
        FirestorageService.uploadImages(images: selectedImages) { [self] urls in
            pinRepository.createPin(pin: Pin(
                id: Auth.auth().currentUser?.uid ?? "",
                title: title,
                content: content,
                longitude: longitude,
                latitude: latitude,
                category: category,
                created: Date().now(),
                urls: urls.map{ $0?.absoluteString ?? "" })
            )
        }
    }
}
