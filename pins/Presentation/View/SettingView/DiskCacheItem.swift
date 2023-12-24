//
//  DiskCacheItem.swift
//  pins
//
//  Created by 주동석 on 12/24/23.
//

import OSLog
import UIKit

final class DiskCacheItem: SettingItemHandling {
    var title: String = "메모리"
    var onPresentAlert: ((UIAlertController) -> Void)?
    
    init(title: String) {
        self.title = title
    }
    
    func performAction() {
        let alert = ConfirmManager.makeAlert(title: "캐시 지우기", message: "모든 캐시를 지우시겠습니까?") { [weak self] in
            self?.removeDiskCache()
            self?.title = "메모리 Zero KB 사용중"
        }
        onPresentAlert?(alert)
    }
    
    private func removeDiskCache() {
        DiskCacheManager.clearCache()
    }
}
