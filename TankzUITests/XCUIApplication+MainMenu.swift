//
//  XCUIApplication+MainMenu.swift
//  TankzUITests
//
//  Created by Martin Langmo Karlstrøm on 07.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import XCTest

extension XCUIApplication {
    var isDisplayingMainMenu: Bool {
        return otherElements["mainMenuView"].exists
    }
}
