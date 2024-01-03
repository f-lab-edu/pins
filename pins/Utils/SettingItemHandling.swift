//
//  SettingItemHandling.swift
//  pins
//
//  Created by 주동석 on 12/24/23.
//

import Foundation

protocol SettingItemHandling {
    var title: String { get set }
    func performAction()
}
