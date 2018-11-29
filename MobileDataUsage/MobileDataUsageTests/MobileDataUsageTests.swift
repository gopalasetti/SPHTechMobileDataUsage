//
//  MobileDataUsageTests.swift
//  MobileDataUsageTests
//
//  Created by Gopalasetti, Siva on 28/11/18.
//  Copyright © 2018 Honeywell. All rights reserved.
//

import XCTest
@testable import MobileDataUsage

class MobileDataUsageTests: XCTestCase {

    var viewController: ViewController!

    let result : [String: Any] = ["help": "https://data.gov.sg/api/3/action/help_show?name=datastore_search", "success": true, "result": ["records" : [["volume_of_mobile_data": "0.171586", "quarter": "2008-Q1", "_id": 15],["volume_of_mobile_data": "0.248899", "quarter": "2008-Q2", "_id": 16],["volume_of_mobile_data": "0.439655", "quarter": "2008-Q3", "_id": 17],["volume_of_mobile_data": "0.683579", "quarter": "2008-Q4", "_id": 18]]]]

    override func setUp() {
        viewController = ViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testServiceData() {
        let service = expectation(description: "MobileDataUsage service")

        viewController.getDataUsageFromServer { (response, json) in
            service.fulfill()
            if let data = json as? [String : Any] {
                if let result = data["result"] as? [String: Any] {
                    if let records = result["records"] as? [[String: Any]] {
                        XCTAssert(records.count > 0, "Records are not receving")
                    } else {
                        XCTAssertFalse(true, "records are not comming in [String: Any] format")
                    }
                } else {
                    XCTAssertFalse(true, "results are not comming in [String: Any] format")
                }
            } else {
                XCTAssertFalse(true, "response is not comming in [String: Any] format")
            }
        }
        
        waitForExpectations(timeout: 20) { (error) in
            if let e = error {
                XCTAssertFalse(true, e.localizedDescription)
            }
        }

    }
    
    func testSaveDataToDB() {
        viewController.saveDataToDB(data: result)
        let fetchResults = Year.fetchYear()
        if fetchResults.count > 0 {
            let year = fetchResults[0]
            if year.name != 2008 {
                XCTAssertFalse(true, "Name is not saved successfully")
            }
        }
    }
    
    func testFetchQuarterByYearAndName() {
        viewController.saveDataToDB(data: result)
        let fetchResults = Year.fetchYear()
        if fetchResults.count > 0 {
            let year = fetchResults[0]
            let quarter = viewController.fetchQuarterByYearAndName(year: year, quarterName: "Q1")
            let dataUsage = quarter?.data
            if dataUsage == nil || dataUsage != 0.171586 {
                XCTAssertFalse(true, "We have not get the correct quarter data")
            }
        }
    }

}
