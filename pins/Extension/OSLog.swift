//
//  Log.swift
//  pins
//
//  Created by 주동석 on 2023/10/26.
//

import OSLog

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let ui = OSLog(subsystem: subsystem, category: "UI")
}
