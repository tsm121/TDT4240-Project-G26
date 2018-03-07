//
//  TankzUITests.swift
//  TankzUITests
//
//  Created by Martin Langmo Karlstrøm on 05.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import XCTest

class TankzUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }
    
    func testMainMenu() {
        let app = XCUIApplication()
        XCTAssertTrue(app.isDisplayingMainMenu)
    }
    
    func testJoinGameView() {
        let app = XCUIApplication()
        app.buttons["Join game"].tap()
        XCTAssertTrue(app.isDisplayingJoinGame)
        app.buttons["Join Game"].tap()
        XCTAssertTrue(app.isDisplayingGameLobby)
        app.buttons["Back"].tap()
        app.buttons["Back"].tap()
        XCTAssertTrue(app.isDisplayingMainMenu)
    }
    
    func testGameView() {
        let app = XCUIApplication()
        app.buttons["Join game"].tap()
        app.buttons["Join Game"].tap()
        app.buttons["Go to gameScene"].tap()
        XCTAssertTrue(app.isDisplayingGame)
        app.buttons["Exit game"].tap()
        XCTAssertTrue(app.isDisplayingMainMenu)
        
    }
    
    func testLobbyView() {
        let app = XCUIApplication()
        app.buttons["Join game"].tap()
        app.buttons["Join Game"].tap()
        XCTAssertTrue(app.isDisplayingGameLobby)
        app.buttons["Back"].tap()
        app.buttons["Back"].tap()
        XCTAssertTrue(app.isDisplayingMainMenu)
    }
    
    
    

    
}
