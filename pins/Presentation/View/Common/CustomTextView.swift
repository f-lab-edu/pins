//
//  CustomTextView.swift
//  pins
//
//  Created by 주동석 on 2023/11/14.
//

import UIKit
import Combine

protocol TextPublisher {
    var textDidChangePublisher: AnyPublisher<String, Never> { get }
}

final class CustomTextView: UITextView {
    private let placeholderColor = UIColor(resource: .placeholderGray)
    private var placeholderLabel: UILabel?
    
    init(placeholder: String, tag: Int) {
        super.init(frame: .zero, textContainer: .none)
        self.tag = tag
        text = NSLocalizedString(placeholder, comment: "")
        textColor = placeholderColor
        font = .preferredFont(forTextStyle: .callout)
        adjustsFontForContentSizeCategory = true
        backgroundColor = UIColor(resource: .background)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTextView: TextPublisher {
    var textDidChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextView)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
