//
//  Test.swift
//  CacheLeaf
//
//  Created by LawLincoln on 2016/9/24.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import XCTest
import Alamofire
@testable import CacheLeaf
class Test: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func asyncTest(timeout: TimeInterval = 30, block: (XCTestExpectation) -> Void) {
        let e: XCTestExpectation = expectation(description: "Swift Expectations")
        block(e)
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if error != nil {
                XCTFail("time out: \(error?.localizedDescription ?? "no error")")
            } else {
                XCTAssert(true, "success")
            }
        }
    }

    func testExample() {
        asyncTest { e in
            let url = URL(string: "https://httpbin.org/")!
            let req = URLRequest(url: url)
            req.execute(cache: 0, ignoreExpires: true, log: true, canCache: { _ in true }) { resp in
                print("😆", resp.isSuccess)
                e.fulfill()
            }
        }
    }

    func testPerformanceExample() {
        asyncTest { e in
            let url = URL(string: "https://httpbin.org/")!
            url.execute(cache: 0, ignoreExpires: true, log: true, canCache: { _ in true }) { resp in
                print("😆", resp.isSuccess)
                e.fulfill()
            }
        }
    }
}
