//
//  Assignment1UITests.swift
//  Assignment1UITests
//
//  Created by Maya Lekova on 1/20/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import XCTest

class Assignment1UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Borrowed from http://masilotti.com/xctest-helpers/
    private func waitForElementToAppear(element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }

    func testNavigation() {
        let app = XCUIApplication()
        app.tables["Empty list"].buttons["Movie"].tap()
        app.searchFields["Search"].typeText("futurama\r")
        
        let app2 = app
        app2.buttons["Episode"].tap()
        app2.buttons["Series"].tap()
        app2.buttons["Movie"].tap()
        
        let firstMovie = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1)
        waitForElementToAppear(element: firstMovie)
        firstMovie.tap()
        
        let backButton = app.navigationBars["Movie Details"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0)
        waitForElementToAppear(element: backButton)
        
        backButton.tap()
    }
}
