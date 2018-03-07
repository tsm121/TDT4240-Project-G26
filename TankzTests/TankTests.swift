//
//  TankTests.swift
//  TankzTests
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import XCTest
@testable import TankzUnitTests

class TankTests: XCTestCase {
    
    var smallTank: SmallTank!
    var bigTank: BigTank!
    var funnyTank: FunnyTank!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        smallTank = SmallTank()
        bigTank = BigTank()
        funnyTank = FunnyTank()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
