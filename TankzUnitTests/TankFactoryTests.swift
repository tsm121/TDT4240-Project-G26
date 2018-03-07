//
//  TankFactoryTests.swift
//  TankzUnitTests
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Tankz

class TankFactoryTests: XCTestCase {
    
    var tankFactory : TankFactory!
    var small : SKShapeNode!
    var big : SKShapeNode!
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        tankFactory = TankFactory()
        small = tankFactory.makeTank(tanktype: .smallTank)
        big = tankFactory.makeTank(tanktype: .bigTank)
        
        
        }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        small = nil
        big = nil
    }
    
    func testTankSize() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(small.frame.width < big.frame.width)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
