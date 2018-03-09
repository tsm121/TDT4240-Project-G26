//
//  TankFactory.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

/*
    The factory can make different kinds of tanks. SmallTank, BigTank and FunnyTank.
    The different tanks is written as different classes inside the TankFactory.
    The tank is "generated" in .makeTank, where the tankType is specified from an enum in GameScene.
 */
class TankFactory {
    
    /**
    Makes the specified tank.
     
     - parameter tanktype: From enum in GameScene (.smallTank, .bigTank, .funnyTank).
     - returns: SKShapenode, the generated tank.
    */
    public let name = "TankFactory Inc."
    
    var iHaveMadeSoManyTanks = 0
    
    public func makeTank(tanktype: TankType, tankName: String, color: UIColor) -> Tank {
        iHaveMadeSoManyTanks += 1
        return Tank(tankType: tanktype, tankName: tankName, color: color)
    }
    
}

