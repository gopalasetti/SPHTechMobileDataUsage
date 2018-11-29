//
//  MobileDataUsageUITests.swift
//  MobileDataUsageUITests
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//

import XCTest

class MobileDataUsageUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    /// To Test weather the year data is displayed
    func testYearDataDisplayed() {
        
        let table = app.tables["Empty list"]
        
        let result = waiterResultWithExpextation(table.otherElements["2008"])
        
        XCTAssert(result == .completed, "Year Data is not Displayed")
        
    }
    

    /// To Test Weather quarter data is displyed on expanding the 2011 year
    func testQuarterDataDisplayed() {
        
        let table = app.tables["Empty list"]

        table.otherElements["2011"].buttons["More Info"].tap()
        
        let tablesQuery = XCUIApplication().tables
        
        let quarterElement = tablesQuery.staticTexts["Q1"]
        
        let result = waiterResultWithExpextation(quarterElement)
        
        XCTAssert(result == .completed, "Quarter Data is not Displayed")

    }
    
    
    /// Wait for the element
    ///
    /// - Parameter element: elemt to wait
    /// - Returns: returns the result of XCWaiter
    func waiterResultWithExpextation(_ element: XCUIElement) -> XCTWaiter.Result {
        let myPredicate = NSPredicate(format: "exists == true")
        let myExpectation = expectation(for: myPredicate, evaluatedWith: element,
                                        handler: nil)
        let result = XCTWaiter().wait(for: [myExpectation], timeout:3)
        return result
    }
}
