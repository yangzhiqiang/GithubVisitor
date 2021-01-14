//
//  DataCenterTest.swift
//  GithubVisitorTests
//
//  Created by David Yang on 2021/1/14.
//

import XCTest
@testable import GithubVisitor

class DataCenterTest: XCTestCase {

    override func setUpWithError() throws {
        DataCenter.shared.initDB()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertRecord() throws {
        let startTime = Int64(Date().timeIntervalSince1970 * 1000)
        let endTime = startTime + 10
        
        let preCount = DataCenter.shared.totalOfRecords()
        
        let insertResult = DataCenter.shared.insertCache(record: CacheRecord(id: 0,
                                                                             startTime: startTime,
                                                                             endTime: endTime,
                                                                             errorCode: 0,
                                                                             statusCode: 200,
                                                                             rawString: "这就是一个测试用例\(startTime)"))
        // check if insert is successful
        XCTAssertTrue(insertResult)
        
        if let record = DataCenter.shared.latestRecord() {
            XCTAssertTrue(record.startTime == startTime)
            XCTAssertTrue(record.endTime == endTime)
        }
        
        let curCount = DataCenter.shared.totalOfRecords()
        XCTAssertTrue((preCount + 1) == curCount)

        let getCount = curCount > 10 ? 10 : curCount
        let records = DataCenter.shared.records(limit: getCount, offset: 0)
        XCTAssertTrue(records.count == getCount)

        let recordsZero = DataCenter.shared.records(limit: 10, offset: 10000000)
        XCTAssertTrue(recordsZero.count == 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
