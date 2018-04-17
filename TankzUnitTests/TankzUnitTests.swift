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
    var small : Tank!
    var big : Tank!
    var funny : Tank!
    
    var mapFactory : MapFactory!
    var map : Map!
    
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
        small = tankFactory.makeTank(tanktype: .smallTank, tankName: "SmallTank", color: UIColor.black, tankdirection: .left)
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 1)
        big = tankFactory.makeTank(tanktype: .bigTank, tankName: "BigTank", color: UIColor.black, tankdirection: .left)
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 2)
        funny = tankFactory.makeTank(tanktype: .funnyTank, tankName: "FunnyTank", color: UIColor.black, tankdirection: .left)
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 3)
        XCTAssertTrue(tankFactory.name.isEqual("TankFactory Inc."))
    }
    
    func testTankSizes() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        small = tankFactory.makeTank(tanktype: .smallTank, tankName: "SmallTank", color: UIColor.black, tankdirection: .left)
        big = tankFactory.makeTank(tanktype: .bigTank, tankName: "BigTank", color: UIColor.black, tankdirection: .left)
        funny = tankFactory.makeTank(tanktype: .funnyTank, tankName: "FunnyTank", color: UIColor.black, tankdirection: .left)
        
        XCTAssertTrue(small.body.frame.height < big.body.frame.height)
        XCTAssertTrue(small.body.frame.height < funny.body.frame.height)
        XCTAssertTrue(big.body.frame.height < funny.body.frame.height)
    }
    
    func testTankNames() {
        small = tankFactory.makeTank(tanktype: .smallTank, tankName: "SmallTank", color: UIColor.black, tankdirection: .left)
        big = tankFactory.makeTank(tanktype: .bigTank, tankName: "BigTank", color: UIColor.black, tankdirection: .left)
        funny = tankFactory.makeTank(tanktype: .funnyTank, tankName: "FunnyTank", color: UIColor.black, tankdirection: .left)
        
        XCTAssertTrue((small.body.name?.isEqual("SmallTank"))!)
        XCTAssertTrue((big.body.name?.isEqual("BigTank"))!)
        XCTAssertTrue((funny.body.name?.isEqual("FunnyTank"))!)
    }
    
    func testTankColors() {
        small = tankFactory.makeTank(tanktype: .smallTank, tankName: "SmallTank", color: UIColor(named: "militaryGreenLight")!, tankdirection: .left)
        big = tankFactory.makeTank(tanktype: .bigTank, tankName: "BigTank", color: UIColor(named: "militaryGreenDark")!, tankdirection: .left)
        funny = tankFactory.makeTank(tanktype: .funnyTank, tankName: "FunnyTank", color: UIColor(named: "militaryRed")!, tankdirection: .left)
        
        XCTAssertTrue(small.body.fillColor == UIColor(named: "militaryGreenLight"))
        XCTAssertTrue(big.body.fillColor == UIColor(named: "militaryGreenDark"))
        XCTAssertTrue(funny.body.fillColor == UIColor(named: "militaryRed"))
    }
    
    func testMapGround() {
        map = mapFactory.makeMap(mapType: .earth)
        XCTAssertTrue((map.ground.name?.isEqual("EarthGround"))!)
        map = mapFactory.makeMap(mapType: .moon)
        XCTAssertTrue((map.ground.name?.isEqual("MoonGround"))!)
        map = mapFactory.makeMap(mapType: .mars)
        XCTAssertTrue((map.ground.name?.isEqual("MarsGround"))!)
    }
    
    func testMapColors() {
        map = mapFactory.makeMap(mapType: .earth)
        XCTAssertTrue(map.ground.fillColor == UIColor(named: "groundBrown")!)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
        }
    }
    
}
