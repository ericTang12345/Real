//
//  RealTests.swift
//  RealTests
//
//  Created by 唐紹桓 on 2020/12/31.
//

import XCTest
@testable import Real

class RealTests: XCTestCase {
    
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
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetVoterCount() throws {
        
        let cell = VoteItemTableViewCell()
        
        XCTAssertEqual(cell.getVoterCount(voter: 1, total: 2), 0.5) // 正常情況：該項目有 1 人投票 全項目投票 2 人，答案應為 0.5/50%
        
        XCTAssertNotEqual(cell.getVoterCount(voter: 1, total: 2), 1) // 算錯的情況
        
        XCTAssertEqual(cell.getVoterCount(voter: 2, total: 3), 0) // 不正常情況：該項目有 2 人投票 全項目投票卻只有 1 人, function 中應該會回傳 0
        
        XCTAssertNotEqual(cell.getVoterCount(voter: 2, total: 1), 1) // 同上不正常情況，回傳 1 即錯誤
    }
}
