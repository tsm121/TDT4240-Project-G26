//
//  Ammo.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 09.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class Ammo {
    public let projectile : SKShapeNode
    public let damage: Double
    public let mass: CGFloat
    public let rad: CGFloat
    public let name : String
    
    init(ammoType: AmmoType) {
        switch ammoType {
        case .missile:
            self.rad = CGFloat(2)
            self.mass = 1
            self.damage = 15.0
            self.name = "Missile"
        case .clusterBomb:
            self.rad = CGFloat(3)
            self.mass = 5
            self.damage = 10.0
            self.name = "ClusterBomb"
        case .funnyBomb:
            self.rad = CGFloat(2)
            self.mass = 10.0
            self.damage = 20.0
            self.name = "FunnyBomb"
        }
        
        self.projectile = SKShapeNode(circleOfRadius: self.rad)
        self.projectile.physicsBody = SKPhysicsBody(circleOfRadius: self.rad)
        self.projectile.fillColor = UIColor.black
        self.projectile.strokeColor = UIColor.black
        self.projectile.name = self.name
        self.projectile.physicsBody?.mass = self.mass
        self.projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        self.projectile.physicsBody?.collisionBitMask = PhysicsCategory.Tank | PhysicsCategory.Ground
        self.projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Tank | PhysicsCategory.Ground
    }
    
}
