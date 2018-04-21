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
    var multiPlayer : Multiplayer!
    
    var tankFactory : TankFactory!
    var light : Tank!
    var med : Tank!
    var heavy : Tank!
    
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
        light = nil
        med = nil
        heavy = nil
        tankFactory = nil
        mapFactory = nil
        map = nil
    }
    
    func testFactory() {
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 0)
        light = tankFactory.makeTank(tankType: .lightTank, forHost: true)
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 1)
        med = tankFactory.makeTank(tankType: .mediumTank, forHost: true)
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 2)
        heavy = tankFactory.makeTank(tankType: .heavyTank, forHost: true)
        XCTAssertTrue(tankFactory.iHaveMadeSoManyTanks == 3)
        XCTAssertTrue(tankFactory.name.isEqual("TankFactory Inc."))
    }
    
    func testTankSizes() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        light = tankFactory.makeTank(tankType: .lightTank, forHost: true)
        med = tankFactory.makeTank(tankType: .mediumTank, forHost: true)
        heavy = tankFactory.makeTank(tankType: .heavyTank, forHost: true)
        
        XCTAssertGreaterThan(light.frame.height, med.frame.height)
        XCTAssertEqual(light.frame.height, heavy.frame.height)
        XCTAssertLessThan(med.frame.height, heavy.frame.height)
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
