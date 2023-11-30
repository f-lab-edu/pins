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

final class CreateViewModel {
    private var createUsecase: CreateUseCaseProtocol
    @Published var selectedImageInfos: [ImageInfo] = []
    @Published var title: String = "제목을 입력해주세요."
    @Published var content: String = "내용을 입력해주세요."
    private var longitude: Double = 0
    private var latitude: Double = 0
    private var category: String = ""
    let pinRepository: FirebaseRepository = FirebaseRepository()
    var selectedCategoryIndex: Int?
    
    init(createUsecase: CreateUseCaseProtocol) {
        self.createUsecase = createUsecase
    }
    
    func getCategoriesCount() -> Int {
        Category.types.count
    }
    
    func didSelectCategory(at index: Int, previouslySelected: Int?) -> (selected: Int, unselected: Int?) {
        selectedCategoryIndex = index
        category = Category.types[index]
        return (index, previouslySelected)
    }
    
    func getSelectedImagesCount() -> Int {
        selectedImageInfos.count
    }
    
    func addSelectedImage(_ image: ImageInfo) {
        selectedImageInfos.append(image)
    }

    func resetSelectedImages() {
        selectedImageInfos.removeAll()
    }
    
    func setPosition(position: CLLocationCoordinate2D) {
        self.longitude = position.longitude
        self.latitude = position.latitude
    }
    
    func getPosition() -> CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func createPin() async {
        let pin = Pin(
            id: title,
            title: content,
            content: category,
            longitude: longitude,
            latitude: latitude,
            category: category,
            created: Date().currentDateTimeAsString()
        )
        await createUsecase.createPin(pin: pin, imageInfos: selectedImageInfos)
    }
}
