//
//  pinsTests.swift
//  pinsTests
//
//  Created by 주동석 on 2023/10/19.
//

import XCTest
@testable import pins

final class pinsTests: XCTestCase {
    // 레파지토리에서 핀을 가져오는 테스트코드
    func testGetPins() async throws {
        let repository = FirebaseRepository()
        let pins = await repository.getPins()
        
        switch pins {
        case .success(let pins):
            print(pins)
            // pins 개수가 0보다 큰지
            XCTAssertGreaterThan(pins.count, 0)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
