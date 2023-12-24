//
//  DiskCacheItem.swift
//  pins
//
//  Created by 주동석 on 12/24/23.
//

import OSLog
import Foundation

final class DiskCacheItem: SettingItemHandling {
    var title: String = "메모리"
    
    init(title: String) {
        self.title = title
    }
    
    func performAction() {
        os_log("메모리 제거")
    }
}
