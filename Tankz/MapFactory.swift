//
//  MapFactory.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class MapFactory {
    
    let width : CGFloat
    
    init(skSceneWidth: CGFloat) {
        self.width = skSceneWidth
    }
    
    func makeMap(MapType: MapType) -> SKShapeNode {
        
        let interval = [0, width*(1/5), width*(2/5), width*(3/5), width*(4/5), width]
        var points = [CGPoint(x: Int(interval[0]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[1]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[2]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[3]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[4]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[5]), y: randHeight(maptype: MapType))]
        
        
        // Draw a BeizerPath from the points. Making it SMOOTH AF.
        let ground = SKShapeNode(splinePoints: &points, count: points.count)
        
        // Add straight lines at border to make closed beizer path.
        let beizer = UIBezierPath(cgPath: ground.path!)
        beizer.move(to: points.first!)
        beizer.addLine(to: CGPoint(x: 0, y: 0))
        beizer.addLine(to: CGPoint(x: self.width, y: 0))
        beizer.addLine(to: points.last!)
        
        // Convert the path to a SKShapeNode and set colors and stuff.
        let shapeNode = SKShapeNode(path: beizer.cgPath)
        shapeNode.strokeColor = UIColor(named: "lightGreen")!
        shapeNode.lineWidth = 1
        shapeNode.fillColor = UIColor(named: "groundBrown")!
        
        // Give it some physics.
        shapeNode.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        shapeNode.physicsBody?.restitution = 0.0
        shapeNode.physicsBody?.friction = 1.0
        shapeNode.physicsBody?.isDynamic = false
        shapeNode.physicsBody?.affectedByGravity = false
        shapeNode.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        shapeNode.physicsBody!.collisionBitMask = PhysicsCategory.Projectile | PhysicsCategory.Tank
        
        // Set name of ground. For testing.
        switch MapType {
        case .flat:
            shapeNode.name = "FlatGround"
        case .flatty:
            shapeNode.name = "FlattyGround"
        case .hills:
            shapeNode.name = "HillsGround"
        }
        
        return shapeNode
    }
    
    func randHeight(maptype: MapType) -> Int{
        let r : Int!
        switch maptype {
        case .flat:
            r = 0
        case .flatty:
            r = 20
        case .hills:
            r = 150
        }
        return Int(arc4random_uniform(UInt32(r))) + Int(50)
    }

    
    
}
