//
//  ReuseIdentifying.swift
//  pins
//
//  Created by 주동석 on 12/23/23.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
