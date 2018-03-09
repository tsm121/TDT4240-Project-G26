//
//  Map.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 09.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class Map {
    
    let height : CGFloat
    var ground : SKShapeNode
    
    init(mapType: MapType, width: CGFloat) {
        switch mapType {
        case .flat:
            self.height = 0
        case .flatty:
            self.height = 20
        case .hills:
            self.height = 15
        }
        
        self.ground = SKShapeNode()
        
        let interval = [0, width*(1/5), width*(2/5), width*(3/5), width*(4/5), width]
        var points = [CGPoint(x: Int(interval[0]), y: randHeight(height: height)),
                      CGPoint(x: Int(interval[1]), y: randHeight(height: height)),
                      CGPoint(x: Int(interval[2]), y: randHeight(height: height)),
                      CGPoint(x: Int(interval[3]), y: randHeight(height: height)),
                      CGPoint(x: Int(interval[4]), y: randHeight(height: height)),
                      CGPoint(x: Int(interval[5]), y: randHeight(height: height))]
        
        
        // Draw a BeizerPath from the points. Making it SMOOTH AF.
        let spline = SKShapeNode(splinePoints: &points, count: points.count)
        
        // Add straight lines at border to make closed beizer path.
        let beizer = UIBezierPath(cgPath: spline.path!)
        beizer.move(to: points.first!)
        beizer.addLine(to: CGPoint(x: 0, y: 0))
        beizer.addLine(to: CGPoint(x: width, y: 0))
        beizer.addLine(to: points.last!)
        
        // Convert the path to a SKShapeNode and set colors and stuff.
        self.ground = SKShapeNode(path: beizer.cgPath)
        self.ground.strokeColor = UIColor(named: "lightGreen")!
        self.ground.lineWidth = 1
        self.ground.fillColor = UIColor(named: "groundBrown")!
        
        switch mapType {
        case .flat:
            self.ground.name = "FlatGround"
        case .flatty:
            self.ground.name = "FlattyGround"
        case .hills:
            self.ground.name = "HillsGround"
        }
        
        // Give it some physics.
        self.ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        self.ground.physicsBody?.restitution = 0.0
        self.ground.physicsBody?.friction = 1.0
        self.ground.physicsBody?.isDynamic = false
        self.ground.physicsBody?.affectedByGravity = false
        self.ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        self.ground.physicsBody!.collisionBitMask = PhysicsCategory.Projectile | PhysicsCategory.Tank
    }
    
    func randHeight(height: CGFloat) -> Int{
        return Int(arc4random_uniform(UInt32(height))) + Int(50)
    }
    
}
