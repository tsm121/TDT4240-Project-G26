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
    
    public func makeTank(tanktype: TankType, tankName: String) -> SKShapeNode {
        var tank : SKShapeNode
        
        switch tanktype {
        case .smallTank:
            tank = SmallTank(tankName: tankName).tank
            tank.physicsBody?.mass = 1
        case .bigTank:
            tank = BigTank(tankName: tankName).tank
            tank.physicsBody?.mass = 3
        case .funnyTank:
            tank = FunnyTank(tankName: tankName).tank
            tank.physicsBody?.mass = 2
        }
        
        
        iHaveMadeSoManyTanks += 1
        
        // Physics on the tank body.
        tank.physicsBody?.affectedByGravity = true
        tank.physicsBody?.friction = 1.0
        tank.physicsBody?.restitution = 0.0
        tank.physicsBody?.linearDamping = 1.0
        tank.physicsBody?.angularDamping = 1.0
        tank.physicsBody!.categoryBitMask = PhysicsCategory.Tank
        tank.physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Projectile | PhysicsCategory.Tank
        tank.physicsBody?.usesPreciseCollisionDetection = true
        
        return tank
    }
    
    // Class for SmallTank
    class SmallTank {
        public var tank: SKShapeNode
        init(tankName: String) {
            tank = SKShapeNode(rectOf: CGSize(width: 20, height: 10))
            tank.fillColor = UIColor(named: "militaryGreenLight")!
            tank.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 10))
            tank.name = tankName
        }
    }
    
    // Class for BigTank
    class BigTank {
        public var tank : SKShapeNode
        init(tankName: String) {
            tank = SKShapeNode(rectOf: CGSize(width: 40, height: 20))
            tank.fillColor = UIColor(named: "militaryGreenDark")!
            tank.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 20))
            tank.name = tankName
        }
    }
    
    // Class for FunnyTank
    class FunnyTank {
        public var tank: SKShapeNode
        init(tankName: String) {
            tank = SKShapeNode(rectOf: CGSize(width: 40, height: 80))
            tank.fillColor = UIColor(named: "militaryRed")!
            tank.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 80))
            tank.name = tankName
        }
    }
    
}
