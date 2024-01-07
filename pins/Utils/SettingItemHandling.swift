//
//  SettingItemHandling.swift
//  pins
//
//  Created by 주동석 on 12/24/23.
//

import UIKit

protocol SettingItemHandling {
    var title: String { get set }
    var onPresentAlert: ((UIAlertController) -> Void)? { get set }
    func performAction()
}
