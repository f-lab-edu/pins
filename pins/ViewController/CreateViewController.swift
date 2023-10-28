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
    var viewModel: CreateViewModel = CreateViewModel()
    var cancellable: Set<AnyCancellable> = []
    var imagePicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
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
        createView.configureCategoryCollectionView(delegate: self, dataSource: self)
        imagePicker.delegate = self
    }
    
    override func loadView() {
        view = CreateView(categoryCount: viewModel.getCategoriesCount())
    }
    
    func setAction() {
        createView.setBackButtonAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        createView.setImageButtonAction(UIAction(handler: { [weak self] _ in
            guard let imagePicker = self?.imagePicker else { return }
            self?.present(imagePicker, animated: true, completion: nil)
        }))
    }

    private func updateCategoryUIForSelection(in collectionView: UICollectionView, selected: Int, unselected: Int?) {
        if let cell = collectionView.cellForItem(at: IndexPath(row: selected, section: 0)) as? CategoryCollectionViewCell {
            cell.isSelect()
        }

        if let unselected = unselected, let previousCell = collectionView.cellForItem(at: IndexPath(row: unselected, section: 0)) as? CategoryCollectionViewCell {
            previousCell.isUnSelect()
        }
    }
}

extension CreateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (selected, unselected) = viewModel.didSelectCategory(at: indexPath.row, previouslySelected: viewModel.selectedCategoryIndex)
        updateCategoryUIForSelection(in: collectionView, selected: selected, unselected: unselected)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCategoriesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.setText(viewModel.categories[indexPath.row])
        return cell
    }
}

extension CreateViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
                
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                print(image)
            }
        }
    }
    
}
