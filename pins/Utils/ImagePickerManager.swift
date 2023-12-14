//
//  ImagePickerManager.swift
//  pins
//
//  Created by 주동석 on 12/7/23.
//

import UIKit
import UniformTypeIdentifiers

enum ImagePickerManager {
    @MainActor
    static func loadImageAsync(_ itemProvider: NSItemProvider) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                if var image = image as? UIImage {
                    image = image.resizeImage(width: 720)
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    @MainActor
    static func loadFileExtension(_ itemProvider: NSItemProvider) async -> String? {
        return await withCheckedContinuation { continuation in
            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                if let url = url {
                    let fileExtension = url.pathExtension
                    continuation.resume(returning: fileExtension)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
