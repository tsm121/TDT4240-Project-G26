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
    public let health: Int
    public let mass: CGFloat
    public let size: CGSize
    public let moveRight: SKAction
    public let moveLeft: SKAction
    
    init(tankType: TankType, tankName: String, color: UIColor) {
        switch tankType {
        case .smallTank:
            self.size = CGSize(width: 10, height: 5)
            self.mass = 10.0
            self.health = 100
            self.moveRight = SKAction.moveBy(x: 20, y: 5, duration: 0.5)
            self.moveLeft = SKAction.moveBy(x: -20, y: 5, duration: 0.5)
        case .bigTank:
            self.size = CGSize(width: 20, height: 10)
            self.mass = 20.0
            self.health = 200
            self.moveRight = SKAction.moveBy(x: 10, y: 5, duration: 0.5)
            self.moveLeft = SKAction.moveBy(x: -10, y: 5, duration: 0.5)
        case .funnyTank:
            self.size = CGSize(width: 15, height: 15)
            self.mass = 15.0
            self.health = 75
            self.moveRight = SKAction.moveBy(x: 20, y: 5, duration: 0.1)
            self.moveLeft = SKAction.moveBy(x: -20, y: 5, duration: 0.1)
        }
        
        self.body = SKShapeNode(rectOf: self.size)
        self.body.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.body.fillColor = color
        self.body.strokeColor = color
        self.body.name = tankName
        self.body.physicsBody?.mass = self.mass
    }
}
