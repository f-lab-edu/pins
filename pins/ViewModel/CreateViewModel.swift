//
//  CreateViewModel.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import Foundation
import UIKit

class CreateViewModel {
    @Published var selectedImages: [UIImage] = []
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
        return categories.count
    }
    
    func didSelectCategory(at index: Int, previouslySelected: Int?) -> (selected: Int, unselected: Int?) {
        selectedCategoryIndex = index
        return (index, previouslySelected)
    }
    
    func isCategorySelected(at index: Int) -> Bool {
        return selectedCategoryIndex == index
    }
    
    func getSelectedImagesCount() -> Int {
        return selectedImages.count
    }
    
    func addSelectedImage(_ image: UIImage) {
        selectedImages.append(image)
    }

    func resetSelectedImages() {
        selectedImages.removeAll()
    }
}
