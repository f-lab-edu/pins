//
//  CategoryCollectionViewHandling.swift
//  pins
//
//  Created by 주동석 on 12/23/23.
//

import UIKit

protocol CategoryCollectionViewHandling: UICollectionViewDelegate, UICollectionViewDataSource { }

class CategoryCollectionViewHandler: NSObject, CategoryCollectionViewHandling {
    private var viewModel: CreateViewModel

    init(viewModel: CreateViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let (selected, unselected) = viewModel.didSelectCategory(at: indexPath.row, previouslySelected: viewModel.selectedCategoryIndex)
        updateCategoryUIForSelection(in: collectionView, selected: selected, unselected: unselected)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCategoriesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        cell.setText(Category.types[indexPath.row])
        return cell
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
}
