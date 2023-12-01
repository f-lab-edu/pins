//
//  DetailViewController.swift
//  pins
//
//  Created by 주동석 on 2023/11/24.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    private var viewModel: DetailViewModel = DetailViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    private var detailView: DetailView {
        view as! DetailView
    }
    
    override func loadView() {
        view = DetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$currentPin.sink { [weak self] pin in
            guard let pin = pin else { return }
            self?.detailView.setPinInfo(pin: pin)
        }.store(in: &cancellable)
        
        detailView.scrollView.delegate = self
        
        setAction()
    }
    
    func setAction() {
        detailView.navigationView.setBackButtonAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
    }
    
    func setPin(pin: PinResponse) {
        viewModel.currentPin = pin
        viewModel.setIsImage(value: !pin.images.isEmpty)
    }
}

extension DetailViewController: UITextFieldDelegate {
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        detailView.navigationView.changeBackgroundColor(as: yOffset)
        if viewModel.isImage {
            detailView.navigationView.changeButtonTintColor(as: yOffset)
            detailView.contentView.updateMainImageHeight(yOffset, scrollView: scrollView, topAnchor: detailView.topAnchor)
        }
    }
}
