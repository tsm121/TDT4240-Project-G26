//
//  Tank.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 09.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class Tank {
    public let body: SKShapeNode
    public var health: Double
    public var damageTaken: Double
    public let mass: CGFloat
    public let size: CGSize
    public var fuel: Int
    public let moveRight: SKAction
    public let moveLeft: SKAction
    
    init(tankType: TankType, tankName: String, color: UIColor) {
        switch tankType {
        case .smallTank:
            self.size = CGSize(width: 10, height: 5)
            self.mass = 10.0
            self.health = 100.0
            self.damageTaken = 0.0
            self.fuel = 20
            self.moveRight = SKAction.moveBy(x: 20, y: 5, duration: 0.5)
            self.moveLeft = SKAction.moveBy(x: -20, y: 5, duration: 0.5)
        case .bigTank:
            self.size = CGSize(width: 20, height: 10)
            self.mass = 20.0
            self.health = 200.0
            self.damageTaken = 0.0
            self.fuel = 10
            self.moveRight = SKAction.moveBy(x: 10, y: 5, duration: 0.5)
            self.moveLeft = SKAction.moveBy(x: -10, y: 5, duration: 0.5)
        case .funnyTank:
            self.size = CGSize(width: 15, height: 15)
            self.mass = 15.0
            self.health = 284.0
            self.damageTaken = 196.0
            self.fuel = 15
            self.moveRight = SKAction.moveBy(x: 20, y: 5, duration: 0.1)
            self.moveLeft = SKAction.moveBy(x: -20, y: 5, duration: 0.1)
        }
        
        self.body = SKShapeNode(rectOf: self.size)
        self.body.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.body.fillColor = color
        self.body.strokeColor = color
        self.body.name = tankName
        
        self.body.physicsBody?.mass = self.mass
        self.body.physicsBody?.affectedByGravity = true
        self.body.physicsBody?.friction = 1.0
        self.body.physicsBody?.restitution = 0.0
        self.body.physicsBody?.linearDamping = 1.0
        self.body.physicsBody?.angularDamping = 1.0
        self.body.physicsBody!.categoryBitMask = PhysicsCategory.Tank
        self.body.physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Projectile | PhysicsCategory.Tank | PhysicsCategory.Ground
        self.body.physicsBody!.contactTestBitMask = PhysicsCategory.Projectile
        self.body.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    public func useFuel() {
        self.fuel -= 1
    }
    
    public func hasFuel() -> Bool {
        if self.fuel >= 1 {
            return true
        } else {return false}
    }
}
