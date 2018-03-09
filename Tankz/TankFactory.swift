//
//  TankFactory.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

// Sets different physicscategories for different objects.
struct PhysicsCategory {
    static let None:        UInt32 = 0      //  0
    static let Edge:        UInt32 = 0b1    //  1
    static let Projectile:  UInt32 = 0b10   //  2
    static let Tank:        UInt32 = 0b100  //  4
    static let Ground:      UInt32 = 0b1000 // 5
}


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
        
        let tank = Tank(tankType: tanktype, tankName: tankName, color: color)
        
        iHaveMadeSoManyTanks += 1
        
        // Physics on the tank body.
        tank.body.physicsBody?.affectedByGravity = true
        tank.body.physicsBody?.friction = 1.0
        tank.body.physicsBody?.restitution = 0.0
        tank.body.physicsBody?.linearDamping = 1.0
        tank.body.physicsBody?.angularDamping = 1.0
        tank.body.physicsBody!.categoryBitMask = PhysicsCategory.Tank
        tank.body.physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Projectile | PhysicsCategory.Tank | PhysicsCategory.Ground
        tank.body.physicsBody?.usesPreciseCollisionDetection = true
        
        return tank
    }
    
}

