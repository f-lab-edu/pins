//
//  ImageCollectionViewHandling.swift
//  pins
//
//  Created by 주동석 on 12/23/23.
//

import UIKit

protocol ImageCollectionViewHandling: UICollectionViewDelegate, UICollectionViewDataSource { }

class ImageCollectionViewHandler: NSObject, ImageCollectionViewHandling {
    private var viewModel: CreateViewModel

    init(viewModel: CreateViewModel) {
        self.viewModel = viewModel
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSelectedImagesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.setImage(image: viewModel.selectedImageInfos[indexPath.row].image)
        return cell
    }
}
