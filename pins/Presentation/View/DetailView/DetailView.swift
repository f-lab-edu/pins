//
//  DetailView.swift
//  pins
//
//  Created by 주동석 on 2023/11/24.
//

import UIKit

final class DetailView: UIView {
    private let animationManager: AnimationManager = AnimationManager()
    let scrollView: DetailScrollView = {
        let scrollView = DetailScrollView()
        scrollView.backgroundColor = .background
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 130)
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    let navigationView: DetailNavigationView = DetailNavigationView()
    let contentView: DetailContentView = DetailContentView()
    private let commentView: DetailCommentView = DetailCommentView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setLayout()
        setKeyboardObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    
    private func setLayout() {
        addSubview(scrollView)
        
        [contentView, commentView, navigationView].forEach {
            scrollView.addSubview($0)
        }
        
        scrollView
            .leadingLayout(equalTo: leadingAnchor)
            .topLayout(equalTo: topAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .bottomLayout(equalTo: bottomAnchor)
        
        navigationView
            .leadingLayout(equalTo: leadingAnchor)
            .topLayout(equalTo: topAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .heightLayout(100)
        
        contentView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: scrollView.topAnchor)
        
        commentView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .bottomLayout(equalTo: bottomAnchor)
            .heightLayout(100)
    }
    
    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height

                let (duration, options) = animationManager.keyboardAnimation(notification: notification)
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    self.commentView
                        .bottomLayout(equalTo: self.bottomAnchor, constant: -keyboardHeight)
                        .heightLayout(70)
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            let (duration, options) = animationManager.keyboardAnimation(notification: notification)
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.commentView
                    .bottomLayout(equalTo: self.bottomAnchor, constant: 0)
                    .heightLayout(100)
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setPinInfo(pin: PinResponse) {
        let image = pin.images.first
        if image == nil {
            navigationView.backButton.tintColor = .black
            contentView.mainImageView.isHidden = true
            contentView.mainImageView.heightLayout(0)
            contentView.topLayout(equalTo: scrollView.topAnchor, constant: 100)
        }
        contentView.setPinContent(title: pin.title, content: pin.content, date: pin.created, image: image, category: pin.category)
    }
}

// MARK: - Extensions
extension DetailView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(resource: .placeholderGray) {
            textView.text = nil
            textView.textColor = UIColor.init(resource: .text)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "댓글을 입력해주세요."
            textView.textColor = UIColor(resource: .placeholderGray)
        }
    }
}
