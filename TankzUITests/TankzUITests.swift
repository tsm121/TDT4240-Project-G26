//
//  TankzUITests.swift
//  TankzUITests
//
//  Created by Martin Langmo Karlstrøm on 07.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import XCTest

class TankzUITests: XCTestCase {
    
    var app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        app.terminate()
    }
    
    func testMainMenu() {
        XCTAssertTrue(app.isDisplayingMainMenu)
    }
    
    func testJoinGameView() {
        app/*@START_MENU_TOKEN@*/.buttons["Join game"]/*[[".otherElements[\"mainMenuView\"].buttons[\"Join game\"]",".buttons[\"Join game\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.isDisplayingJoinGame)
    }
    
    func testLobbyView() {
        app/*@START_MENU_TOKEN@*/.buttons["Create game"]/*[[".otherElements[\"mainMenuView\"].buttons[\"Create game\"]",".buttons[\"Create game\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.isDisplayingGameLobby)
        // Add test for joining lobby from host-list.

    }
    
    func testScoreboardView() {
        app.buttons["Scoreboard"].tap()
        XCTAssertTrue(app.isDisplayingScoreboard)
    }
    
    func testGameView() {
        app/*@START_MENU_TOKEN@*/.buttons["Create game"]/*[[".otherElements[\"mainMenuView\"].buttons[\"Create game\"]",".buttons[\"Create game\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Go to gameScene"].tap()
        XCTAssertTrue(app.isDisplayingGame)
    }
    
    func testFullUI() {
        app/*@START_MENU_TOKEN@*/.buttons["Create game"]/*[[".otherElements[\"mainMenuView\"].buttons[\"Create game\"]",".buttons[\"Create game\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Tankz.GameLobbyView"].buttons["Back"].tap()
        XCTAssertTrue(app.isDisplayingMainMenu)
        app/*@START_MENU_TOKEN@*/.buttons["Join game"]/*[[".otherElements[\"mainMenuView\"].buttons[\"Join game\"]",".buttons[\"Join game\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.isDisplayingJoinGame)
        app.navigationBars["Tankz.JoinGameView"].buttons["Back"].tap()
        XCTAssertTrue(app.isDisplayingMainMenu)
        app.buttons["Scoreboard"].tap()
        XCTAssertTrue(app.isDisplayingScoreboard)
        app.navigationBars["Tankz.ScoreboardView"].buttons["Back"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Create game"]/*[[".otherElements[\"mainMenuView\"].buttons[\"Create game\"]",".buttons[\"Create game\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Go to gameScene"].tap()
        XCTAssertTrue(app.isDisplayingGame)
        app.buttons["Exit game"].tap()
        XCTAssertTrue(app.isDisplayingMainMenu)
    }
    
}
