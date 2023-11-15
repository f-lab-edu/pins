//
//  CreateViewController.swift
//  pins
//
//  Created by 주동석 on 2023/10/24.
//

import UIKit
import Combine
import PhotosUI

class CreateViewController: UIViewController {
    private enum CollectionViewType: Int {
        case CategoryCollection
        case ImageCollection
    }
    var viewModel: CreateViewModel = CreateViewModel()
    var cancellable: Set<AnyCancellable> = []
    var loadingIndicator: LoadingIndicator = LoadingIndicator()
    var imagePicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }()
    var createView: CreateView {
        view as! CreateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAction()
        bindViewModel()
        createView.configureCategoryCollectionView(delegate: self, dataSource: self)
        imagePicker.delegate = self
    }
    
    override func loadView() {
        view = CreateView(categoryCount: viewModel.getCategoriesCount())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func bindViewModel() {
        viewModel.$selectedImages.sink { [weak self] images in
            self?.createView.reloadImageCollectionView()
            self?.createView.setPhotoCount(count: images.count)
        }.store(in: &cancellable)
        
        createView.titleTextView.textDidChangePublisher
            .assign(to: \.title, on: viewModel)
            .store(in: &cancellable)
        
        createView.contentTextView.textDidChangePublisher
            .assign(to: \.content, on: viewModel)
            .store(in: &cancellable)
    }
    
    private func setAction() {
        createView.setBackButtonAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        createView.setImageButtonAction(UIAction(handler: { [weak self] _ in
            guard let imagePicker = self?.imagePicker else { return }
            self?.present(imagePicker, animated: true, completion: nil)
        }))
        
        createView.setCreateButtonAction(UIAction(handler: { [weak self] _ in
            self?.loadingIndicator.showLoading(with: "핀 생성 중입니다...")

            self?.viewModel.createPin() {
                self?.loadingIndicator.hideLoading()
                self?.navigationController?.popViewController(animated: true)
            }
        }))
    }

    private func updateCategoryUIForSelection(in collectionView: UICollectionView, selected: Int, unselected: Int?) {
        guard selected != unselected else { return }
        
        if let cell = collectionView.cellForItem(at: IndexPath(row: selected, section: 0)) as? CategoryCollectionViewCell {
            cell.isSelect()
        }

        if let unselected = unselected, let previousCell = collectionView.cellForItem(at: IndexPath(row: unselected, section: 0)) as? CategoryCollectionViewCell {
            previousCell.isUnSelect()
        }
    }
    
    private func loadUIImage(from itemProvider: NSItemProvider, completion: @escaping (UIImage) -> Void) {
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    completion(image)
                }
            }
        }
    }
}

extension CreateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch CollectionViewType(rawValue: collectionView.tag) {
        case .CategoryCollection:
            let (selected, unselected) = viewModel.didSelectCategory(at: indexPath.row, previouslySelected: viewModel.selectedCategoryIndex)
            updateCategoryUIForSelection(in: collectionView, selected: selected, unselected: unselected)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CollectionViewType(rawValue: collectionView.tag) {
        case .CategoryCollection:
            return viewModel.getCategoriesCount()
        case .ImageCollection:
            return viewModel.getSelectedImagesCount()
        default:
            fatalError("wrong collection view tag")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch CollectionViewType(rawValue: collectionView.tag) {
        case .CategoryCollection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            cell.setText(viewModel.categories[indexPath.row])
            return cell
        case .ImageCollection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            cell.setImage(image: viewModel.selectedImages[indexPath.row])
            return cell
        default:
            fatalError("wrong collection view tag")
        }
    }
}

extension CreateViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        viewModel.resetSelectedImages()
        results.forEach { result in
            loadUIImage(from: result.itemProvider) { [weak self] image in
                DispatchQueue.main.async {
                    self?.viewModel.addSelectedImage(image)
                }
            }
        }
    }
}
