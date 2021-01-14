//
//  GithubVisitorTests.swift
//  GithubVisitorTests
//
//  Created by David Yang on 2021/1/14.
//

import XCTest
@testable import GithubVisitor

class GithubVisitorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class GitbubNetworkTests: XCTestCase {
    func testLoad() throws {
        let expectNormal = expectation(description: "Request should OK")
        GithubNetworkOperation.shared.load(path: "/") { (error, dict) in
            XCTAssertTrue(error == nil)
            XCTAssertTrue(dict != nil)
            
            expectNormal.fulfill()
        }
        
        let expectNotexist = expectation(description: "Request should fail")
        GithubNetworkOperation.shared.load(path: "/notexist") { (error, dict) in
            XCTAssertTrue(error != nil)
            XCTAssertTrue(dict == nil)
            
            expectNotexist.fulfill()
        }

        self.wait(for: [expectNormal, expectNotexist, ], timeout: 10)
    }
    
    func testEndpoit() throws {
        let expectNormal = expectation(description: "Request should OK")
        
        GithubNetworkOperation.shared.visitEndpoint() { (error, dict) in
            XCTAssertTrue(error == nil)
            XCTAssertTrue(dict != nil)
            
            XCTAssertTrue(dict?["current_user_url"] != nil)
            XCTAssertTrue(dict?["current_user_url"] as? String != nil)

            expectNormal.fulfill()
        }
        
        wait(for: [expectNormal], timeout: 10)
    }
}
