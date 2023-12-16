//
//  SnapshotTest.swift
//  pinsTests
//
//  Created by 주동석 on 12/16/23.
//

import XCTest
import SnapshotTesting
@testable import pins

final class SnapshotTestTests: XCTestCase {
    func testExample() throws {
        let sut = LoginViewController()
        assertSnapshots(of: sut, as: [Snapshotting<UIViewController, UIImage>.image])
    }
}
