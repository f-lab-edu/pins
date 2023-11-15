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
        "create.category.friendship",
        "create.category.walk",
        "create.category.game",
        "create.category.exercise",
        "create.category.study",
        "create.category.neighbor",
        "create.category.food",
        "create.category.culture",
        "create.category.etc",
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
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func createPin(completion: @escaping () -> Void) {
        FirestorageService.uploadImages(images: selectedImages) { [self] urls in
            pinRepository.createPin(pin: Pin(
                id: Auth.auth().currentUser?.uid ?? "",
                title: title,
                content: content,
                longitude: longitude,
                latitude: latitude,
                category: category,
                created: Date().currentDateTimeAsString(),
                urls: urls.map{ $0?.absoluteString ?? "" })
            ) {
                completion()
            }
        }
    }
}
