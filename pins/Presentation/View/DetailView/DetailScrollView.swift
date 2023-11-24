//
//  DetailScrollView.swift
//  pins
//
//  Created by 주동석 on 11/24/23.
//

import UIKit

protocol ScrollViewTouchHandling {
    func handleScrollViewTouches()
}

extension ScrollViewTouchHandling where Self: UIView {
    func handleScrollViewTouches() {
        self.endEditing(true)
    }
}

class DetailScrollView: UIScrollView, ScrollViewTouchHandling {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleScrollViewTouches()
    }
}
