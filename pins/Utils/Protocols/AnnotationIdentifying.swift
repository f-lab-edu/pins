//
//  AnnotationIdentifying.swift
//  pins
//
//  Created by 주동석 on 12/24/23.
//

import Foundation

protocol AnnotationIdentifying {
    static var identifier: String { get }
}

extension AnnotationIdentifying {
    static var identifier: String {
        return String(describing: self)
    }
}
