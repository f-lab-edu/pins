//
//  SettingViewModel.swift
//  pins
//
//  Created by 주동석 on 12/24/23.
//

import Foundation

final class SettingViewModel {
    private var tableData: [SettingItemHandling] = []
    
    init(tableData: [SettingItemHandling]) {
        self.tableData = tableData
    }
    
    func getTableData() -> [SettingItemHandling] {
        return tableData
    }
    
    func getTableStringData() -> [String] {
        return tableData.map { $0.title }
    }
}
