//
//  Ammo.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 09.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class Ammo : SKShapeNode {
    public let damage: Double
    public let mass: CGFloat
    public let rad: CGFloat
    
    init(ammoType: AmmoType) {
        switch ammoType {
            case .missile:
                self.rad = CGFloat(2)
                self.mass = 1
                self.damage = 15.0
                super.init()
                self.name = "Missile"
            case .clusterBomb:
                self.rad = CGFloat(3)
                self.mass = 5
                self.damage = 10.0
                super.init()
                self.name = "ClusterBomb"
            case .funnyBomb:
                self.rad = CGFloat(2)
                self.mass = 10.0
                self.damage = 20.0
                super.init()
                self.name = "FunnyBomb"
        }
        self.initAsCircle()
        self.initPhysicsBody()
        
        
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Game Function
    
    public func collided(position: CGPoint){
        let explosion = Explosion()
        explosion.position = position
        self.parent?.addChild(explosion)
        self.removeFromParent()
        explosion.explode()
    }
    // Helper Functions
    private func initAsCircle(){
        let diameter = self.rad * 2
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter)), transform: nil)
        self.fillColor = UIColor.black
        self.strokeColor = UIColor.black
    }
    
    private func initPhysicsBody(){
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.rad)
        self.physicsBody?.mass = self.mass
        self.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        self.physicsBody?.collisionBitMask = PhysicsCategory.Tank | PhysicsCategory.Ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Tank | PhysicsCategory.Ground
    }
    
}
