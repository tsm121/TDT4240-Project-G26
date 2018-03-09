//
//  Tank.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 09.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class Tank {
    public var body: SKShapeNode
    public var health: Int
    public var mass: CGFloat
    public var size: CGSize
    
    init(tankType: TankType, tankName: String, color: UIColor) {
        switch tankType {
        case .smallTank:
            self.size = CGSize(width: 10, height: 5)
            self.mass = 10.0
            self.health = 100
        case .bigTank:
            self.size = CGSize(width: 20, height: 10)
            self.mass = 20.0
            self.health = 200
        case .funnyTank:
            self.size = CGSize(width: 15, height: 15)
            self.mass = 15.0
            self.health = 75
        }
        
        self.body = SKShapeNode(rectOf: self.size)
        self.body.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.body.fillColor = color
        self.body.strokeColor = color
        self.body.name = tankName
        self.body.physicsBody?.mass = self.mass
    }
}
