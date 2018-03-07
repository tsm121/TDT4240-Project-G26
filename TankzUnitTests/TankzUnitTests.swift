//
//  TankzUnitTests.swift
//  TankzUnitTests
//
//  Created by Martin Langmo Karlstrøm on 07.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import XCTest
import SpriteKit
@testable import Tankz


class TankzUnitTests: XCTestCase {
    
    var factory : TankFactory!
    var small : SKShapeNode!
    var big : SKShapeNode!
    var funny : SKShapeNode!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        factory = TankFactory()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        small = nil
        big = nil
        funny = nil
        factory = nil
    }
    
    func testFactory() {
        XCTAssertTrue(factory.iHaveMadeSoManyTanks == 0)
        small = factory.makeTank(tanktype: .smallTank)
        XCTAssertTrue(factory.iHaveMadeSoManyTanks == 1)
        big = factory.makeTank(tanktype: .bigTank)
        XCTAssertTrue(factory.iHaveMadeSoManyTanks == 2)
        funny = factory.makeTank(tanktype: .funnyTank)
        XCTAssertTrue(factory.iHaveMadeSoManyTanks == 3)
    }
    
    func testTankSizes() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        small = factory.makeTank(tanktype: .smallTank)
        big = factory.makeTank(tanktype: .bigTank)
        funny = factory.makeTank(tanktype: .funnyTank)
        
        XCTAssertTrue(small.frame.height < big.frame.height)
        XCTAssertTrue(small.frame.height < funny.frame.height)
        XCTAssertTrue(big.frame.height < funny.frame.height)
    }
    
    func testTankNames() {
        small = factory.makeTank(tanktype: .smallTank)
        big = factory.makeTank(tanktype: .bigTank)
        funny = factory.makeTank(tanktype: .funnyTank)
        
        XCTAssertTrue((small.name?.isEqual("SmallTank"))!)
        XCTAssertTrue((big.name?.isEqual("BigTank"))!)
        XCTAssertTrue((funny.name?.isEqual("FunnyTank"))!)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
