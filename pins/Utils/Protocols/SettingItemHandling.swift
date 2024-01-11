//
//  SettingItemHandling.swift
//  pins
//
//  Created by 주동석 on 1/3/24.
//

import Foundation

protocol SettingItemHandling {
    var title: String { get set }
    func performAction()
}
