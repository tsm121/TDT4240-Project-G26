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
    
    var gameScene : GameScene!
    
    var tankFactory : TankFactory!
    var small : SKShapeNode!
    var big : SKShapeNode!
    var funny : SKShapeNode!
    
    var mapFactory : MapFactory!
    var map : SKShapeNode!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        gameScene = GameScene()
        tankFactory = TankFactory()
        mapFactory = MapFactory(skSceneWidth: gameScene.frame.width)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        small = nil
        big = nil
        funny = nil
        tankFactory = nil
        mapFactory = nil
        map = nil
    }
    
    func testFactory() {
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 0)
        small = tankFactory.makeTank(tanktype: .smallTank)
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 1)
        big = tankFactory.makeTank(tanktype: .bigTank)
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 2)
        funny = tankFactory.makeTank(tanktype: .funnyTank)
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 3)
    }
    
    func testTankSizes() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        small = tankFactory.makeTank(tanktype: .smallTank)
        big = tankFactory.makeTank(tanktype: .bigTank)
        funny = tankFactory.makeTank(tanktype: .funnyTank)
        
        XCTAssertTrue(small.frame.height < big.frame.height)
        XCTAssertTrue(small.frame.height < funny.frame.height)
        XCTAssertTrue(big.frame.height < funny.frame.height)
    }
    
    func testTankNames() {
        small = tankFactory.makeTank(tanktype: .smallTank)
        big = tankFactory.makeTank(tanktype: .bigTank)
        funny = tankFactory.makeTank(tanktype: .funnyTank)
        
        XCTAssertTrue((small.name?.isEqual("SmallTank"))!)
        XCTAssertTrue((big.name?.isEqual("BigTank"))!)
        XCTAssertTrue((funny.name?.isEqual("FunnyTank"))!)
    }
    
    func testMapGround() {
        map = mapFactory.makeMap(MapType: .flat)
        XCTAssertTrue((map.name?.isEqual("FlatGround"))!)
        map = mapFactory.makeMap(MapType: .flatty)
        XCTAssertTrue((map.name?.isEqual("FlattyGround"))!)
        map = mapFactory.makeMap(MapType: .hills)
        XCTAssertTrue((map.name?.isEqual("HillsGround"))!)
    }
    
    func testMapColors() {
        // map = mapFactory.makeMap(MapType: .flat)
        // XCTAssertTrue(map.fillColor.isEqual(UIColor(named: "groundBrown")))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
