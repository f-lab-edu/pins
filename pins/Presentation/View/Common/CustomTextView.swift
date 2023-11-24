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
    func adjustForKeyboard()
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

extension CustomTextView: TextPublisher{
    var textDidChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextView)?.text ?? "" }
            .eraseToAnyPublisher()
    }
    
    func adjustForKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            self.handleKeyboard(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
            self.handleKeyboard(notification: notification)
        }
    }
    
    private func handleKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        if notification.name == UIResponder.keyboardWillShowNotification {
            // 키보드가 나타날 때, CustomTextView가 키보드에 가려지지 않도록 위치 조정
            if let superview = self.superview {
                let bottomSpace = superview.frame.height - (self.frame.origin.y + self.frame.height)
                let offset = keyboardHeight - bottomSpace

                if offset > 0 {
                    // 뷰를 위로 올려 키보드에 가려지지 않도록 합니다.
                    UIView.animate(withDuration: 0.3) {
                        self.transform = CGAffineTransform(translationX: 0, y: -offset)
                    }
                }
            }
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            // 키보드가 사라질 때, CustomTextView의 위치를 원래대로 되돌립니다.
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}
