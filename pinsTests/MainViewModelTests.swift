//
//  pinsTests.swift
//  pinsTests
//
//  Created by 주동석 on 2023/10/19.
//

import XCTest
@testable import pins

class MockUserService: UserServiceProtocol {
    func putUser(user: pins.UserRequest) {
        fatalError("Not implemented")
    }
    
    var mockUser: UserRequest = UserRequest(id: "testId", nickName: "testNickname", firstTime: false, profileImage: "testImage")

    func getUser(id: String) async -> UserRequest? {
        return mockUser
    }
}

class MockFirestorageService: FirestorageServiceProtocol {
    func uploadImage(imageInfo: pins.ImageInfo) async -> pins.URLWithIndex {
        fatalError("Not implemented")
    }
    
    func uploadImages(imageInfos: [pins.ImageInfo]) async -> [pins.URLWithIndex] {
        fatalError("Not implemented")
    }
    
    func createPin(pin: pins.PinRequest, images: [pins.ImageInfo]) async {
        fatalError("Not implemented")
    }
    
    var mockPins: [PinRequest] = [PinRequest(id: "testId", title: "testTitle", content: "testContent", longitude: 0.0, latitude: 0.0, category: "testCategory", created: "testCreated", userId: "testUserId", urls: ["testUrl"])]
    var mockImage: UIImage = UIImage() // 테스트를 위한 기본 이미지

    func getPins() async -> [PinRequest] {
        return mockPins
    }

    func downloadImage(urlString: String) async -> UIImage? {
        return mockImage
    }
}

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
    
    func testGetCurrentPins_WhenCalled_ShouldReturnMockPinsFromService() async {
        // When
        await viewModel.setCurrentPins()
        
        // Then
        XCTAssertEqual(viewModel.currentPins, mockFirestorageService.mockPins, "getPins should return the pins from the mock service")
    }
    
    func testSetCurrentPins_WhenFails_ShouldNotUpdateCurrentPins() async {
        // Given
        mockFirestorageService.mockPins = []

        // When
        await viewModel.setCurrentPins()

        // Then
        XCTAssertTrue(viewModel.currentPins.isEmpty, "currentPins should not be updated on failure")
    }
    
    func testLoadPin_WhenCalledWithPinRequest_ShouldReturnValidPinResponse() async {
        // Given
        let pinRequest = PinRequest(id: "testId", title: "testTitle", content: "testContent", longitude: 0.0, latitude: 0.0, category: "testCategory", created: "testCreated", userId: "testUserId", urls: ["testUrl"])

        // When
        let response = await viewModel.loadPin(pin: pinRequest)

        // Then
        XCTAssertNotNil(response, "loadPin should return a valid PinResponse")
    }
    
    func testLoadPin_WhenCalledWithPinRequest_ShouldReturnPinResponseWithCorrectImageCount() async {
        // Given
        let pinRequest = PinRequest(id: "testId", title: "testTitle", content: "testContent", longitude: 0.0, latitude: 0.0, category: "testCategory", created: "testCreated", userId: "testUserId", urls: ["testUrl"])

        // When
        let response = await viewModel.loadPin(pin: pinRequest)

        // Then
        XCTAssertNotNil(response, "loadPin should return a valid PinResponse")
        XCTAssertEqual(response.images.count, pinRequest.urls.count, "The number of images should match the number of URLs in the pin request")
    }
    
    func testFetchUserInfo_WhenCalled_ShouldReturnMockUserFromService() async {
        // When
        let userInfo = await viewModel.getUserInfo()

        // Then
        XCTAssertEqual(userInfo, mockUserService.mockUser, "fetchUserInfo should return the user from the mock service")
    }

    func testSetCreateViewIsPresented_WhenSetToTrue_ShouldReflectTrueState() {
        // When
        viewModel.setCreateViewIsPresented(isPresented: true)

        // Then
        XCTAssertTrue(viewModel.getCreateViewIsPresented(), "createViewIsPresented should be true")
    }

    func testGetCreateViewIsPresented_WhenPreviouslySetToTrue_ShouldReturnTrue() {
        // Given
        viewModel.setCreateViewIsPresented(isPresented: true)

        // When
        let isPresented = viewModel.getCreateViewIsPresented()

        // Then
        XCTAssertTrue(isPresented, "getCreateViewIsPresented should return true")
    }

    func testToggleCreateViewIsPresented_WhenToggled_ShouldInverseInitialValue() {
        // Given
        let initialValue = viewModel.getCreateViewIsPresented()

        // When
        viewModel.toggleCreateViewIsPresented()

        // Then
        XCTAssertNotEqual(viewModel.getCreateViewIsPresented(), initialValue, "createViewIsPresented should be toggled")
    }
}
