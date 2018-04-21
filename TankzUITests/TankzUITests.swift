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
    
    func testGameLobbyView() {
        
        // app.otherElements["mainMenuView"].children(matching: .button).matching(identifier: "Button").element(boundBy: 0).tap()
        
    }
    
    func testJoinGameView() {
        app.otherElements["mainMenuView"].children(matching: .button).matching(identifier: "Button").element(boundBy: 1).tap()
        XCTAssertTrue(app.isDisplayingJoinGame)
        app.navigationBars["Tankz.JoinGameView"].buttons["Back"].tap()
        XCTAssertTrue(app.isDisplayingMainMenu)
    }
    
    
    func testGameView() {
        app.otherElements["mainMenuView"].children(matching: .button).matching(identifier: "Button").element(boundBy: 0).tap()
        XCTAssertTrue(app.isDisplayingGameLobby)
        app/*@START_MENU_TOKEN@*/.buttons["Go to gameScene"]/*[[".otherElements[\"gameLobbyView\"].buttons[\"Go to gameScene\"]",".buttons[\"Go to gameScene\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.isDisplayingGame)
        app/*@START_MENU_TOKEN@*/.buttons["Exit game"]/*[[".otherElements[\"gameView\"].buttons[\"Exit game\"]",".buttons[\"Exit game\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.isDisplayingMainMenu)

        
    }
    
}
