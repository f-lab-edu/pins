//
//  pinsTests.swift
//  pinsTests
//
//  Created by 주동석 on 2023/10/19.
//

import XCTest
@testable import pins

final class MainViewModelTests: XCTestCase {
    var mockFirestorageService: MockFirestorageService!
    var mockUserService: MockUserService!
    var useCase: MainUseCase!
    var viewModel: MainViewModel!

    override func setUp() {
        super.setUp()
        mockFirestorageService = MockFirestorageService()
        mockUserService = MockUserService()
        useCase = MainUseCase(firestorageService: mockFirestorageService, userService: mockUserService)
        viewModel = MainViewModel(mainUseCase: useCase)
    }
    
    func test_현재핀목록가져오기_호출시_mockService로부터반환() async {
        // When
        await viewModel.setCurrentPins()
        
        // Then
        XCTAssertEqual(viewModel.currentPins, mockFirestorageService.mockPins, "getPins should return the pins from the mock service")
    }
    
    func test_핀로드_핀요청시_유효한핀응답반환() async {
        // Given
        let pinRequest = PinRequest(id: "testId", title: "testTitle", content: "testContent", longitude: 0.0, latitude: 0.0, category: "testCategory", created: "testCreated", userId: "testUserId", urls: ["testUrl"])

        Task {
            // When
            let response = try await viewModel.loadPin(pin: pinRequest)
            
            // Then
            XCTAssertNotNil(response, "loadPin should return a valid PinResponse")
        }
    }
    
    func test_핀로드_핀요청시_정확한이미지수반환() async {
        // Given
        let pinRequest = PinRequest(id: "testId", title: "testTitle", content: "testContent", longitude: 0.0, latitude: 0.0, category: "testCategory", created: "testCreated", userId: "testUserId", urls: ["testUrl"])

        Task {
            // When
            let response = try await viewModel.loadPin(pin: pinRequest)

            // Then
            XCTAssertEqual(response.images.count, pinRequest.urls.count, "The number of images should match the number of URLs in the pin request")
        }
    }
    
    func test_사용자정보가져오기_호출시_mockService로부터사용자반환() async {
        Task {
            // When
            let userInfo = try await viewModel.getUserInfo()
            
            // Then
            XCTAssertEqual(userInfo, mockUserService.mockUser, "fetchUserInfo should return the user from the mock service")
        }
    }
    
    func test_createView표시설정_true로설정시_상태반영() {
        // When
        viewModel.setCreateViewIsPresented(isPresented: true)

        // Then
        XCTAssertTrue(viewModel.getCreateViewIsPresented(), "createViewIsPresented should be true")
    }

    func test_createView표시설정_이전에true로설정됐을때_true반환() {
        // Given
        viewModel.setCreateViewIsPresented(isPresented: true)

        // When
        let isPresented = viewModel.getCreateViewIsPresented()

        // Then
        XCTAssertTrue(isPresented, "getCreateViewIsPresented should return true")
    }

    func test_createView표시토글_토글시_초기값반대로변경() {
        // Given
        let initialValue = viewModel.getCreateViewIsPresented()

        // When
        viewModel.toggleCreateViewIsPresented()

        // Then
        XCTAssertNotEqual(viewModel.getCreateViewIsPresented(), initialValue, "createViewIsPresented should be toggled")
    }
}
