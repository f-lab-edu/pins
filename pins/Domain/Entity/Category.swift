//
//  Category.swift
//  pins
//
//  Created by 주동석 on 11/23/23.
//

import Foundation

enum Category: String, CaseIterable {
    case friendship = "create.category.friendship"
    case walk = "create.category.walk"
    case game = "create.category.game"
    case exercise = "create.category.exercise"
    case study = "create.category.study"
    case pet = "create.category.pet"
    case food = "create.category.food"
    case culture = "create.category.culture"
    case etc = "create.category.etc"

    var imageName: String {
        switch self {
        case .culture:
            return "CulturePin"
        case .exercise:
            return "ExercisePin"
        case .food:
            return "FoodPin"
        case .friendship:
            return "FriendshipPin"
        case .game:
            return "GamePin"
        case .walk:
            return "WalkPin"
        case .study:
            return "StudyPin"
        case .pet:
            return "PetPin"
        case .etc:
            return "etc"
        }
    }
    
    static var types: [String] {
        return Category.allCases.map { $0.rawValue }
    }
}
