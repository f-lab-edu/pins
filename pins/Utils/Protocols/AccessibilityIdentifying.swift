//
//  AccessibilityIdentifying.swift
//  pins
//
//  Created by 주동석 on 12/23/23.
//

import UIKit

protocol AccessibilityIdentifiable {
    var accessibilityIdentifierValue: String { get }
    func setAccessibilityIdentifier()
}

extension UIView: AccessibilityIdentifiable {
    var accessibilityIdentifierValue: String {
        String(describing: type(of: self))
    }

    func setAccessibilityIdentifier() {
        self.accessibilityIdentifier = accessibilityIdentifierValue
    }
}
