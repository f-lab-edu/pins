//
//  Category.swift
//  pins
//
//  Created by 주동석 on 11/23/23.
//

import Foundation

enum Category {
    static let types: [String] = [
        "create.category.friendship",
        "create.category.walk",
        "create.category.game",
        "create.category.exercise",
        "create.category.study",
        "create.category.pet",
        "create.category.food",
        "create.category.culture",
        "create.category.etc",
    ]
    
    static func convertToImageName(category: String?) -> String {
        switch category {
        case "create.category.culture":
            return "CulturePin"
        case "create.category.exercise":
            return "ExercisePin"
        case "create.category.food":
            return "FoodPin"
        case "create.category.friendship":
            return "FriendshipPin"
        case "create.category.game":
            return "GamePin"
        case "create.category.walk":
            return "WalkPin"
        case "create.category.study":
            return "StudyPin"
        case "create.category.pet":
            return "PetPin"
        case "create.category.etc":
            return "etc"
        default:
            return "etc"
        }
    }
}
