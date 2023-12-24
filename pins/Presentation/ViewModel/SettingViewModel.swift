//
//  SettingViewModel.swift
//  pins
//
//  Created by 주동석 on 12/24/23.
//

import Foundation

final class SettingViewModel {
    private let tableData: [String] = ["로그아웃", "현재 캐시 100MB"]
    
    func getTableData() -> [String] {
        return tableData
    }
}
