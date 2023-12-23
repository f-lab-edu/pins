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
    private lazy var categoryCollectionViewHandler = CategoryCollectionViewHandler(viewModel: viewModel)
    private lazy var imageCollectionViewHandler = ImageCollectionViewHandler(viewModel: viewModel)

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
        createView.configureCategoryCollectionView(handler: categoryCollectionViewHandler)
        createView.configureImageCollectionView(handler: imageCollectionViewHandler)
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
    
    private func processPickerResult(_ index: Int, _ result: PHPickerResult) {
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            Task {
                let image = await ImagePickerManager.loadImageAsync(result.itemProvider)
                let extensionType = await ImagePickerManager.loadFileExtension(result.itemProvider)
                if let image = image, let extensionType = extensionType {
                    await MainActor.run {
                        viewModel.addSelectedImage(ImageInfo(index: index, image: image, extensionType: extensionType))
                    }
                }
            }
        }
    }
    
    func setPosition(_ position: CLLocationCoordinate2D) {
        viewModel.setPosition(position: position)
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
