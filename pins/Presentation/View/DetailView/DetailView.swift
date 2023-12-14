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
    private enum ScrollViewType: Int {
        case totalScroll
        case imageBannerScroll
    }
    private struct UIConstants {
        static let bannerHeight: CGFloat = 300
        static let navigationHeight: CGFloat = 100
        static let commentHeight: CGFloat = 100
        static let extendedScreenHeight: CGFloat = UIScreenUtils.getScreenHeight() + 130
        static let labelCornerRadius: CGFloat = 12
        static let labelFontSize: CGFloat = 12
        static let labelInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        static let initialImageCountText: String = "0/0"
    }
    private let scrollView: DetailScrollView = {
        let scrollView = DetailScrollView()
        scrollView.backgroundColor = .background
        scrollView.contentSize = CGSize(width: UIScreenUtils.getScreenWidth(), height: UIConstants.extendedScreenHeight)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.tag = 0
        return scrollView
    }()
    private let bannerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.tag = 1
        return scrollView
    }()
    private var imageViews: [UIImageView] = []
    private let imageCountLabel: PaddingLabel = {
        let label = PaddingLabel(inset: UIConstants.labelInsets)
        label.font = .systemFont(ofSize: UIConstants.labelFontSize, weight: .medium)
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.textColor = .white
        label.setCornerRadius(offset: UIConstants.labelCornerRadius)
        label.text = UIConstants.initialImageCountText
        label.layer.zPosition = 2
        return label
    }()
    private let contentView: DetailContentView = DetailContentView()
    let commentView: DetailCommentView = DetailCommentView()
    let navigationView: DetailNavigationView = DetailNavigationView()
    // MARK: - Property
    private let animationManager: AnimationManager = AnimationManager()
    private var viewModel: DetailViewModel
    private var cancellable = Set<AnyCancellable>()
    // MARK: - Initializer
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setLayout()
        setKeyboardObserver()
        setBinding()
        scrollView.delegate = self
        bannerScrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented because this view is not designed to be initialized from a nib or storyboard.")
    }
    // MARK: - Method
    private func setBinding() {
        viewModel.$page.sink { [weak self] value in
            guard let self else { return }
            self.imageCountLabel.text = "\(value)/\(self.viewModel.getImages().count)"
        }.store(in: &cancellable)
        
        viewModel.$comments.receive(on: DispatchQueue.main)
            .sink { [weak self] comments in
            guard let self else { return }
            self.contentView.setComments(comments: comments)
        }.store(in: &cancellable)
    }

    private func setLayout() {
        addSubview(scrollView)
        [bannerScrollView, contentView, commentView, navigationView].forEach {
            scrollView.addSubview($0)
        }
        setupBannerScrollView()
        bannerScrollView.addSubview(imageCountLabel)
        
        scrollView
            .leadingLayout(equalTo: leadingAnchor)
            .topLayout(equalTo: topAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .bottomLayout(equalTo: bottomAnchor)
        
        contentView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .topLayout(equalTo: scrollView.topAnchor, constant: UIConstants.bannerHeight)
            .heightLayout(UIScreenUtils.getScreenHeight() - UIConstants.bannerHeight - UIConstants.commentHeight)
    
        bannerScrollView
            .topLayout(equalTo: scrollView.topAnchor)
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .heightLayout(UIConstants.bannerHeight)
        
        navigationView
            .leadingLayout(equalTo: leadingAnchor)
            .topLayout(equalTo: topAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .heightLayout(UIConstants.navigationHeight)
        
        commentView
            .leadingLayout(equalTo: leadingAnchor)
            .trailingLayout(equalTo: trailingAnchor)
            .bottomLayout(equalTo: bottomAnchor)
            .heightLayout(UIConstants.commentHeight)
        
        imageCountLabel
            .bottomLayout(equalTo: contentView.topAnchor, constant: -20)
            .trailingLayout(equalTo: trailingAnchor, constant: -15)
    }
    
    private func setupBannerScrollView() {
        for image in viewModel.getImages() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageViews.append(imageView)
            bannerScrollView.addSubview(imageView)
        }

        updateBannerScrollViewLayout()
        updateImageZIndex(page: 0)
    }
    
    private func updateBannerScrollViewLayout() {
        for (index, imageView) in imageViews.enumerated() {
            imageView
                .leadingLayout(equalTo: bannerScrollView.leadingAnchor, constant: UIScreenUtils.getScreenWidth() * CGFloat(index))
                .topLayout(equalTo: bannerScrollView.topAnchor)
                .widthLayout(UIScreenUtils.getScreenWidth())
                .heightLayout(UIConstants.bannerHeight)
        }
        bannerScrollView.contentSize = CGSize(width: UIScreenUtils.getScreenWidth() * CGFloat(imageViews.count), height: UIConstants.bannerHeight)
    }
    
    private func setKeyboardObserver() {
        let keyboardAnimationManager = KeyboardAnimationManager()
        keyboardAnimationManager.setKeyboardObservers { keyboardHeight, isKeyboardVisible in
            if isKeyboardVisible {
                self.commentView.bottomLayout(equalTo: self.bottomAnchor, constant: -keyboardHeight)
                    .heightLayout(UIConstants.commentHeight * 0.7)
            } else {
                self.commentView.bottomLayout(equalTo: self.bottomAnchor, constant: 0)
                    .heightLayout(UIConstants.commentHeight)
            }
            self.layoutIfNeeded()
        }
    }
    
    func setPinInfoDepondingOnImageExistence(pin: PinResponse) {
        if pin.images.isEmpty {
            imageCountLabel.removeFromSuperview()
            bannerScrollView.removeFromSuperview()
            navigationView.backButton.tintColor = .black
            contentView.topLayout(equalTo: scrollView.topAnchor, constant: UIConstants.navigationHeight)
        } else {
            contentView.topLayout(equalTo: scrollView.topAnchor, constant: UIConstants.bannerHeight)
        }
        contentView.setPinContent(pin: pin)
    }
    
    private func updateImageScale(_ offset: CGFloat) {
        if offset < 0 {
            bannerScrollView.isScrollEnabled = false
            bannerScrollView.topLayout(equalTo: topAnchor)
            bannerScrollView.heightLayout(UIConstants.bannerHeight - offset)
            let scale = 1 - offset / UIConstants.bannerHeight * 2
            let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
            
            for imageView in imageViews {
                imageView.transform = scaleTransform
            }
        } else {
            bannerScrollView.isScrollEnabled = true
            bannerScrollView.topLayout(equalTo: scrollView.topAnchor)
            bannerScrollView.heightLayout(UIConstants.bannerHeight)
            resetImageScale()
        }
    }

    private func resetImageScale() {
        for imageView in imageViews {
            imageView.transform = .identity
        }
    }
    
    private func updateImageZIndex(page: Int) {
        for (index, imageView) in imageViews.enumerated() {
            if index == page {
                imageView.layer.zPosition = 1
            } else {
                imageView.layer.zPosition = 0
            }
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
        switch ScrollViewType(rawValue: scrollView.tag) {
        case .imageBannerScroll:
            let page = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            viewModel.setPage(value: page + 1)
            updateImageZIndex(page: page)
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch ScrollViewType(rawValue: scrollView.tag) {
        case .totalScroll:
            let yOffset = scrollView.contentOffset.y
            navigationView.changeBackgroundColor(as: yOffset)
            if viewModel.isImage {
                navigationView.changeButtonTintColor(as: yOffset)
                updateImageScale(yOffset)
            }
        default:
            break
        }
    }
}
