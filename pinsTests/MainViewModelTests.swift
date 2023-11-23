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
        // 예상되는 Pins 데이터 설정
        let expectedPins: [Pin] = [/* ... 여기에 Pin 배열 초기화 ... */]
        mockMainUseCase.mockPins = expectedPins

        // getPins 메소드 실행
        viewModel.getPins()

        // 결과 검증
        XCTAssertEqual(viewModel.currentPins, expectedPins, "getPins 메소드가 올바르게 Pins를 가져오지 못함")
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
    var mockPins: [Pin] = []

    func getPins() async -> [Pin] {
        return mockPins
    }
}
