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
    let backgroundHeight : CGFloat
    var wallpaper : SKShapeNode
    
    init(mapType: MapType, width: CGFloat) {
        self.height = 20
        
        switch mapType {
        case .earth:
            self.backgroundHeight = 200
        case .mars:
            self.backgroundHeight = 250
        case .moon:
            self.backgroundHeight = 300
        }
        
        self.ground = SKShapeNode()
        self.wallpaper = SKShapeNode()
        
        makeGround(mapType: mapType, width: width)
        makeWallpaper(mapType: mapType, width: width)
    }
    
    func makeGround(mapType: MapType, width: CGFloat) {
        
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
        self.ground.lineWidth = 1
        
        // Map colors for the ground.
        switch mapType {
        case .earth:
            self.ground.name = "EarthGround"
            self.ground.fillColor = UIColor(named: "groundBrown")!
            self.ground.strokeColor = UIColor(named: "lightGreen")!
        case .mars:
            self.ground.name = "MarsGround"
            self.ground.fillColor = UIColor(red: 247/255, green: 159/255, blue: 121/255, alpha: 1)
            self.ground.strokeColor = UIColor(red: 247/255, green: 159/255, blue: 121/255, alpha: 1)
        case .moon:
            self.ground.name = "MoonGround"
            self.ground.fillColor = UIColor(red: 194/255, green: 187/255, blue: 240/255, alpha: 1)
            self.ground.strokeColor = UIColor(red: 194/255, green: 187/255, blue: 240/255, alpha: 1)
        }
        
        // Give it some physics.
        self.ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        self.ground.physicsBody?.restitution = 0.0
        self.ground.physicsBody?.friction = 1.0
        self.ground.physicsBody?.isDynamic = false
        self.ground.physicsBody?.affectedByGravity = false
        self.ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        self.ground.physicsBody!.collisionBitMask = PhysicsCategory.Projectile | PhysicsCategory.Tank
        self.ground.physicsBody!.contactTestBitMask = PhysicsCategory.Projectile
        
    }
    
    func makeWallpaper(mapType: MapType, width: CGFloat) {
        
        let interval = [0, width*(1/5), width*(2/5), width*(3/5), width*(4/5), width]
        var points = [CGPoint(x: Int(interval[0]), y: randHeight(height: backgroundHeight)),
                      CGPoint(x: Int(interval[1]), y: randHeight(height: backgroundHeight)),
                      CGPoint(x: Int(interval[2]), y: randHeight(height: backgroundHeight)),
                      CGPoint(x: Int(interval[3]), y: randHeight(height: backgroundHeight)),
                      CGPoint(x: Int(interval[4]), y: randHeight(height: backgroundHeight)),
                      CGPoint(x: Int(interval[5]), y: randHeight(height: backgroundHeight))]
        
        
        // Draw a BeizerPath from the points. Making it SMOOTH AF.
        let spline = SKShapeNode(splinePoints: &points, count: points.count)
        
        // Add straight lines at border to make closed beizer path.
        let beizer = UIBezierPath(cgPath: spline.path!)
        beizer.move(to: points.first!)
        beizer.addLine(to: CGPoint(x: 0, y: 0))
        beizer.addLine(to: CGPoint(x: width, y: 0))
        beizer.addLine(to: points.last!)
        
        // Convert the path to a SKShapeNode and set colors and stuff.
        self.wallpaper = SKShapeNode(path: beizer.cgPath)
        self.wallpaper.lineWidth = 1
        
        // Map colors for the ground.
        switch mapType {
        case .earth:
            self.wallpaper.name = "EarthGround"
            self.wallpaper.fillColor = UIColor(named: "lightGreen")!.withAlphaComponent(0.5)
            self.wallpaper.strokeColor = UIColor(named: "lightGreen")!.withAlphaComponent(0.5)
        case .mars:
            self.wallpaper.name = "MarsGround"
            self.wallpaper.fillColor = UIColor(red: 247/255, green: 208/255, blue: 138/255, alpha: 0.5)
            self.wallpaper.strokeColor = UIColor(red: 247/255, green: 208/255, blue: 138/255, alpha: 0.5)
        case .moon:
            self.wallpaper.name = "MoonGround"
            self.wallpaper.fillColor = UIColor(red: 241/255, green: 227/255, blue: 243/255, alpha: 0.5)
            self.wallpaper.strokeColor = UIColor(red: 241/255, green: 227/255, blue: 243/255, alpha: 0.5)
        }
    }
    
    
    
        
    
    func randHeight(height: CGFloat) -> Int{
        return Int(arc4random_uniform(UInt32(height))) + Int(50)
    }
    
}
