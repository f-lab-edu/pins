//
//  pinsTests.swift
//  pinsTests
//
//  Created by 주동석 on 2023/10/19.
//

import XCTest
@testable import pins

final class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockMainUseCase: MockMainUseCase!

    override func setUp() {
        super.setUp()
        mockMainUseCase = MockMainUseCase()
        viewModel = MainViewModel(mainUseCase: mockMainUseCase)
    }
    
    func testGetPins() async {
        let expectation = XCTestExpectation(description: "getPins completes")
        let expectedPins: [Pin] = [
            Pin(id: "1", title: "title", content: "content", longitude: 1, latitude: 2, category: "category", created: "created")
        ]
        mockMainUseCase.pinsToReturn = expectedPins

        viewModel.getPins()
        
        var receivedPins: [Pin] = []
        let cancellable = viewModel.$currentPins.sink { pins in
            receivedPins = pins
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1)

        XCTAssertEqual(receivedPins, expectedPins)

        cancellable.cancel()
    }

    func testSetCreateViewIsPresented() {
        // setCreateViewIsPresented 메소드 실행
        viewModel.setCreateViewIsPresented(isPresented: true)

        // 결과 검증
        XCTAssertTrue(viewModel.getCreateViewIsPresented(), "setCreateViewIsPresented 메소드가 상태를 올바르게 설정하지 못함")
    }

    func testToggleCreateViewIsPresented() {
        // 처음 상태를 false로 설정
        viewModel.setCreateViewIsPresented(isPresented: false)
        // toggleCreateViewIsPresented 메소드 실행
        viewModel.toggleCreateViewIsPresented()

        // 결과 검증
        XCTAssertTrue(viewModel.getCreateViewIsPresented(), "toggleCreateViewIsPresented 메소드가 상태를 올바르게 토글하지 못함")
    }
}

class MockMainUseCase: MainUseCaseProtocol {
    var pinsToReturn: [Pin] = []

    func getPins() async -> [Pin] {
        return pinsToReturn
    }
}
