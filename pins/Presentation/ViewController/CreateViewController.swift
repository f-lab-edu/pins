//
//  CreateViewController.swift
//  pins
//
//  Created by 주동석 on 2023/10/24.
//

import UIKit
import Combine
import PhotosUI

final class CreateViewController: UIViewController {
    private lazy var firebaseRepository: FirebaseRepositoryProtocol = FirebaseRepository()
    private lazy var firebaseStorageService: FirestorageServiceProtocol = FirestorageService(firebaseRepository: firebaseRepository)
    private lazy var createUseCase: CreateUseCaseProtocol = CreateUseCase(firestorageService: firebaseStorageService)
    private lazy var viewModel: CreateViewModel = CreateViewModel(createUsecase: createUseCase)
    private enum CollectionViewType: Int {
        case categoryCollection
        case imageCollection
    }
    private var cancellable: Set<AnyCancellable> = []
    private var loadingIndicator: LoadingIndicator = LoadingIndicator()
    private var imagePicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }()
    private var createView: CreateView {
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
        viewModel.$selectedImageInfos.sink { [weak self] images in
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

            Task {
                await self?.viewModel.createPin()
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
    
    private func processPickerResult(_ index: Int, _ result: PHPickerResult) {
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            Task {
                let image = await loadImageAsync(result.itemProvider)
                let extensionType = await loadFileExtension(result.itemProvider)
                if let image = image, let extensionType = extensionType {
                    await MainActor.run {
                        viewModel.addSelectedImage(ImageInfo(index: index, image: image, extensionType: extensionType))
                    }
                }
            }
        }
    }

    private func loadImageAsync(_ itemProvider: NSItemProvider) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if var image = image as? UIImage {
                    image = image.resizeImageTo40Percent()
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    private func loadFileExtension(_ itemProvider: NSItemProvider) async -> String? {
        return await withCheckedContinuation { continuation in
            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                if let url = url {
                    let fileExtension = url.pathExtension
                    continuation.resume(returning: fileExtension)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func setPosition(_ position :CLLocationCoordinate2D) {
        viewModel.setPosition(position: position)
    }
}

extension CreateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch CollectionViewType(rawValue: collectionView.tag) {
        case .categoryCollection:
            let (selected, unselected) = viewModel.didSelectCategory(at: indexPath.row, previouslySelected: viewModel.selectedCategoryIndex)
            updateCategoryUIForSelection(in: collectionView, selected: selected, unselected: unselected)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CollectionViewType(rawValue: collectionView.tag) {
        case .categoryCollection:
            return viewModel.getCategoriesCount()
        case .imageCollection:
            return viewModel.getSelectedImagesCount()
        default:
            fatalError("wrong collection view tag")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch CollectionViewType(rawValue: collectionView.tag) {
        case .categoryCollection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            cell.setText(Category.types[indexPath.row])
            return cell
        case .imageCollection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            cell.setImage(image: viewModel.selectedImageInfos[indexPath.row].image)
            return cell
        default:
            fatalError("wrong collection view tag")
        }
    }
}

extension CreateViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        for (index, result) in results.enumerated() {
            processPickerResult(index, result)
        }
    }
}
