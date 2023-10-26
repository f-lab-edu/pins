//
//  CreateViewController.swift
//  pins
//
//  Created by 주동석 on 2023/10/24.
//

import UIKit
import Combine

class CreateViewController: UIViewController {
    var viewModel: CreateViewModel = CreateViewModel()
    var cancellable: Set<AnyCancellable> = []
    var createView: CreateView {
        view as! CreateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAction()
        createView.configureCategoryCollectionView(delegate: self, dataSource: self)
    }
    
    override func loadView() {
        view = CreateView(categoryCount: viewModel.getCategoriesCount())
    }
    
    func setAction() {
        createView.setBackButtonAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
    }
}

extension CreateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        
        if let index = viewModel.selectedCategoryIndex {
            guard let previousCell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? CategoryCollectionViewCell else { return }
            previousCell.isUnSelect()
        }
        
        viewModel.selectCategory(at: indexPath.row)
        cell.isSelect()
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
