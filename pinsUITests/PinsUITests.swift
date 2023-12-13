//
//  pinsUITests.swift
//  pinsUITests
//
//  Created by 주동석 on 2023/10/19.
//

import XCTest

final class PinsUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testDetailView() throws {
        let app = XCUIApplication()
        app.launch()
        
        let pins = app.otherElements["지도 핀"]
        pins.firstMatch.tap()

        let nameLabel = app.staticTexts["nameLabel"]
        let personalInfo = app.staticTexts["personalInfo"]
        let categoryLabel = app.staticTexts["categoryLabel"]
        let titleLabel = app.staticTexts["titleLabel"]
        let dateLabel = app.staticTexts["dateLabel"]
        let contentLabel = app.staticTexts["contentLabel"]
        let commentLabel = app.staticTexts["commentLabel"]
        
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: nameLabel, handler: nil)
        expectation(for: exists, evaluatedWith: personalInfo, handler: nil)
        expectation(for: exists, evaluatedWith: categoryLabel, handler: nil)
        expectation(for: exists, evaluatedWith: titleLabel, handler: nil)
        expectation(for: exists, evaluatedWith: dateLabel, handler: nil)
        expectation(for: exists, evaluatedWith: contentLabel, handler: nil)
        expectation(for: exists, evaluatedWith: commentLabel, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let elements = [nameLabel, personalInfo, categoryLabel, titleLabel, dateLabel, contentLabel, commentLabel]
        
        for element in elements {
            XCTAssertTrue(element.exists, "Element \(element) does not exist")
        }
    }
}
