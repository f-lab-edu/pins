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
            return "culturePin"
        case .exercise:
            return "exercisePin"
        case .food:
            return "foodPin"
        case .friendship:
            return "friendshipPin"
        case .game:
            return "gamePin"
        case .walk:
            return "walkPin"
        case .study:
            return "studyPin"
        case .pet:
            return "petPin"
        case .etc:
            return "etc"
        }
    }
    
    static var types: [String] {
        return Category.allCases.map { $0.rawValue }
    }
}
