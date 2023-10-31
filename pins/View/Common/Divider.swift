//
//  Divider.swift
//  pins
//
//  Created by 주동석 on 10/26/23.
//

import UIKit

class Divider: UIView {
    init(backgroundColor: UIColor = .extraLightGray, thickness: CGFloat = 1) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: thickness).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
