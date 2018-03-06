//
//  MapFactory.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class MapFactory {
    
    let skScene : SKScene
    
    init(skScene: SKScene) {
        self.skScene = skScene
    }
    
    func makeMap(MapType: MapType) -> SKShapeNode {
        
        let interval = [0, skScene.size.width*(1/5), skScene.size.width*(2/5), skScene.size.width*(3/5), skScene.size.width*(4/5), skScene.size.width]
        var points = [CGPoint(x: Int(interval[0]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[1]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[2]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[3]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[4]), y: randHeight(maptype: MapType)),
                      CGPoint(x: Int(interval[5]), y: randHeight(maptype: MapType))]
        
        //let linearShapeNode = SKShapeNode(points: &points, count: points.count)
        let ground = SKShapeNode(splinePoints: &points, count: points.count)
        ground.strokeColor = UIColor.red
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.0
        ground.physicsBody?.friction = 1.0
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.affectedByGravity = false
        return ground
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
