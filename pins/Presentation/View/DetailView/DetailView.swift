//
//  DetailView.swift
//  pins
//
//  Created by 주동석 on 2023/11/24.
//

import UIKit
import Combine

final class DetailView: UIView {
    // MARK: - UI Property
    private let scrollView: DetailScrollView = {
        let scrollView = DetailScrollView()
        scrollView.backgroundColor = .background
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 130)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.tag = 0
        return scrollView
    }()
    
    private let bannerCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailBannerCell.self, forCellWithReuseIdentifier: DetailBannerCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.tag = 1
        return collectionView
    }()
    
    private let imageCountLabel: PaddingLabel = {
        let label = PaddingLabel(topInset: 4, bottomInset: 4, leftInset: 8, rightInset: 8)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.textColor = .white
        label.setCornerRadius(offset: 12)
        label.text = "0/0"
        return label
    }()
    
    private let contentView: DetailContentView = DetailContentView()
    private let commentView: DetailCommentView = DetailCommentView()
    let navigationView: DetailNavigationView = DetailNavigationView()
    // MARK: - Property
    private let animationManager: AnimationManager = AnimationManager()
    private var viewModel: DetailViewModel!
    private var cancellable = Set<AnyCancellable>()
    // MARK: - Initializer
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setLayout()
        setKeyboardObserver()
        setBinding()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    // MARK: - Method
    private func setBinding() {
        viewModel.$page.sink { [weak self] value in
            guard let self = self else { return }
            self.imageCountLabel.text = "\(value)/\(self.viewModel.getImages().count)"
        }.store(in: &cancellable)
    }
    
    private func setLayout() {
        addSubview(scrollView)
        [bannerCollectionView, contentView, commentView, navigationView].forEach {
            scrollView.addSubview($0)
        }
        bannerCollectionView.addSubview(imageCountLabel)
        
        scrollView
            .leadingLayout(equalTo: leadingAnchor)
            .topLayout(equalTo: topAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .bottomLayout(equalTo: bottomAnchor)
        
        contentView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .heightLayout(UIScreen.main.bounds.height - 400)
            .topLayout(equalTo: scrollView.topAnchor, constant: 300)
    
        bannerCollectionView
            .topLayout(equalTo: scrollView.topAnchor)
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .heightLayout(300)
        
        navigationView
            .leadingLayout(equalTo: leadingAnchor)
            .topLayout(equalTo: topAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .heightLayout(100)
        
        commentView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .bottomLayout(equalTo: bottomAnchor)
            .heightLayout(100)
        
        imageCountLabel
            .bottomLayout(equalTo: contentView.topAnchor, constant: -20)
            .trailingLayout(equalTo: trailingAnchor, constant: -15)
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
    
    func setPinInfoDepondingOnImageExistence(pin: PinResponse) {
        if pin.images.isEmpty {
            imageCountLabel.removeFromSuperview()
            bannerCollectionView.removeFromSuperview()
            navigationView.backButton.tintColor = .black
            contentView.topLayout(equalTo: scrollView.topAnchor, constant: 100)
        } else {
            contentView.topLayout(equalTo: scrollView.topAnchor, constant: 300)
        }
        contentView.setPinContent(title: pin.title, content: pin.content, date: pin.created, category: pin.category)
    }
    
    func updateImageScale(_ offset: CGFloat) {
        if offset < 0 {
            bannerCollectionView.isScrollEnabled = false
            bannerCollectionView.topLayout(equalTo: topAnchor)
            bannerCollectionView.heightLayout(300 - offset)
            let scale = 1 - offset / 300
            let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
            for cell in bannerCollectionView.visibleCells {
                guard let bannerCell = cell as? DetailBannerCell else { continue }
                bannerCell.bannerImageView.transform = scaleTransform
            }
        } else {
            bannerCollectionView.topLayout(equalTo: scrollView.topAnchor)
            bannerCollectionView.isScrollEnabled = true
            bannerCollectionView.contentOffset = .zero
            bannerCollectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
            bannerCollectionView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(viewModel.getImages().count), height: 300)
        }
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

extension DetailView: UICollectionViewDelegate {
}

extension DetailView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getImages().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let images = viewModel.getImages()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailBannerCell.identifier, for: indexPath) as! DetailBannerCell
        cell.bannerImageView.image = images[indexPath.item]
        return cell
    }
}

extension DetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension DetailView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.setPage(value: Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 0 {
            let yOffset = scrollView.contentOffset.y
            navigationView.changeBackgroundColor(as: yOffset)
            if viewModel.isImage {
                navigationView.changeButtonTintColor(as: yOffset)
                updateImageScale(yOffset)
            }
        }
    }
}

