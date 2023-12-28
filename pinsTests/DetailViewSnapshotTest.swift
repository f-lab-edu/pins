import iOSSnapshotTestCase
@testable import pins

final class DetailViewSnapshotTest: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        self.recordMode = false
    }
    
    func test_DetailViewController_WithNoImage() {
        let detailVC = DetailViewController()
        let pinRequest = PinRequest(id: "testId", title: "test title", content: "test content", longitude: 0.0, latitude: 0.0, category: "산책", created: "", userId: "testUser")
        detailVC.setPin(pin: PinResponse(pin: pinRequest, images: [], id: "testUser", name: "user1", age: 20, description: "desc", profile: UIImage(resource: .test).pngData()!))
        FBSnapshotVerifyViewController(detailVC)
    }
    
    func test_DetailViewController_WithImage() {
        let detailVC = DetailViewController()
        let pinRequest = PinRequest(id: "testId", title: "test title", content: "test content", longitude: 0.0, latitude: 0.0, category: "산책", created: "", userId: "testUser")
        detailVC.setPin(pin: PinResponse(pin: pinRequest, images: [UIImage(resource: .test).pngData()!], id: "testUser", name: "user1", age: 20, description: "desc", profile: UIImage(resource: .test).pngData()!))
        FBSnapshotVerifyViewController(detailVC)
    }
}
