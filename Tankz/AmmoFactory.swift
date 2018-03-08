//
//  AmmoFactory.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit


class AmmoFactory {
    
    let touchDownPos : CGPoint
    let touchUpPos : CGPoint
    let tank : SKShapeNode
    
    init(touchDownPos : CGPoint, touchUpPos : CGPoint, tank : SKShapeNode) {
        self.touchDownPos = touchDownPos
        self.touchUpPos = touchUpPos
        self.tank = tank                    //Shooting tank
    }
    
    public func makeAmmo(ammotype: AmmoType) -> SKShapeNode          {
        var ammo : SKShapeNode
        switch ammotype {
        case .missile:
            ammo = Missile().ammo
        case .clusterBomb:
            ammo = ClusterBomb().ammo
        case .funnyBomb:
            ammo = FunnyBomb().ammo
        }
        
        // Physics on ammo
        ammo.physicsBody?.affectedByGravity = true
        ammo.physicsBody?.mass = 1
        ammo.physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        ammo.physicsBody?.usesPreciseCollisionDetection = true
        ammo.position = CGPoint(x: self.tank.position.x , y: self.tank.position.y + 10) //+10 inntil vi fikser collision så den ikke treffer seg selv
        return ammo
    }
    
    // Class for Missile
    class Missile: SKShapeNode {
        public var ammo: SKShapeNode
        override init() {
            ammo = SKShapeNode(rectOf: CGSize(width: 4, height: 4))
            ammo.fillColor = UIColor.black
            ammo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 4, height: 4))
            ammo.name = "Missile"
            super.init()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // Class for ClusterBomb
    class ClusterBomb: SKShapeNode {
        public var ammo: SKShapeNode
        override init() {
            ammo = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
            ammo.fillColor = UIColor.black
            ammo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
            ammo.name = "ClusterBomb"
            super.init()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // Class for FunnyBomb
    class FunnyBomb: SKShapeNode {
        public var ammo: SKShapeNode
        override init() {
            ammo = SKShapeNode(rectOf: CGSize(width: 60, height: 2))
            ammo.fillColor = UIColor.black
            ammo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 2))
            ammo.name = "FunnyBomb"
            super.init()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
}
