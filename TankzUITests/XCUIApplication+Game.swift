//
//  XCUIApplication+GameView.swift
//  TankzUITests
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import XCTest

extension XCUIApplication {
    var isDisplayingGame: Bool {
        return otherElements["gameView"].exists
    }
}
