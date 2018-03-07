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
    
    let name = "TankFactory Inc."
    var iHaveMadeSoManyTanks = 0
    
    public func makeTank(tanktype: TankType) -> SKShapeNode {
        var tank : SKShapeNode
        switch tanktype {
        case .smallTank:
            tank = SmallTank().tank
        case .bigTank:
            tank = BigTank().tank
        case .funnyTank:
            tank = FunnyTank().tank
        }
        
        iHaveMadeSoManyTanks += 1
        
        
        
        // Physics on the tank body.
        tank.physicsBody?.affectedByGravity = true
        tank.physicsBody?.mass = 1
        tank.physicsBody?.friction = 1.0
        tank.physicsBody?.restitution = 0.0
        tank.physicsBody?.linearDamping = 0.0
        tank.physicsBody?.angularDamping = 0.0
        tank.physicsBody!.categoryBitMask = PhysicsCategory.Tank
        tank.physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Projectile
        tank.physicsBody?.usesPreciseCollisionDetection = true
        tank.position = CGPoint(x: 300 + tank.frame.width/2,y: 400 + tank.frame.height/2)
        return tank
    }
    
    // Class for SmallTank
    class SmallTank: SKShapeNode {
        public var tank: SKShapeNode
        override init() {
            tank = SKShapeNode(rectOf: CGSize(width: 20, height: 10))
            tank.fillColor = UIColor.black
            tank.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 10))
            tank.name = "SmallTank"
            super.init()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // Class for BigTank
    class BigTank: SKShapeNode {
        public var tank : SKShapeNode
        override init() {
            tank = SKShapeNode(rectOf: CGSize(width: 40, height: 20))
            tank.fillColor = UIColor.brown
            tank.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 20))
            tank.name = "BigTank"
            super.init()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // Class for FunnyTank
    class FunnyTank: SKShapeNode {
        public var tank: SKShapeNode
        override init() {
            tank = SKShapeNode(rectOf: CGSize(width: 40, height: 80))
            tank.fillColor = UIColor.green
            tank.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 40, height: 80))
            tank.name = "FunnyTank"
            super.init()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
