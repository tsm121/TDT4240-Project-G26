//
//  TankFactory.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

/*
    The tank factory class.
    Redundant.
 */

class TankFactory {
    
    public let name = "TankFactory Inc."
    
    var iHaveMadeSoManyTanks = 0
    
    
    /**
     Runs explosion animation on collision.
     - parameter tankType: Type of tank.
     - parameter forHost: If tank is host or not.
     - returns: Tank object.
     */
    public func makeTank(tankType: TankType, forHost: Bool) -> Tank {
        iHaveMadeSoManyTanks += 1
        return Tank(ofType: tankType, forHost: forHost);
    }
    
}

