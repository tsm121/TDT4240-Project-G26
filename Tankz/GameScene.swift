//
//  GameScene.swift
//  Tankz
//
//  Created by Thomas Markussen on 05/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit
import GameplayKit


// Tank types.
enum TankType {
    case smallTank
    case bigTank
    case funnyTank
}

// Map types.
enum MapType {
    case flat
    case flatty
    case hills
}

// Ammo types.
enum AmmoType {
    case missile
    case clusterBomb
    case funnyBomb
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var viewController: GameViewController!
    
    private var tankFactory : TankFactory!
    private var mapFactory : MapFactory!
    private var tank1 : SKShapeNode!
    private var tank2 : SKShapeNode!
    private var map : SKShapeNode!
    private var height : CGFloat!
    private var width : CGFloat!
    
    private var leftButton : SKShapeNode!
    private var rightButton : SKShapeNode!

    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // Create game area, full screen.
        self.createArea()
        self.createButtons()
        
        // Generate the world map.
        mapFactory = MapFactory(skSceneWidth: CGFloat(self.size.width))
        map = mapFactory.makeMap(MapType: .hills)
        self.addChild(map)
        
        
        // Generate a tank from the factory.
        tankFactory = TankFactory()
        tank1 = tankFactory.makeTank(tanktype: .bigTank, tankName: "Player 1")
        placeTank(tank: tank1)
        tank2 = tankFactory.makeTank(tanktype: .funnyTank, tankName: "Player 2")
        placeTank(tank: tank2)
        
        self.addChild(tank1)
        self.addChild(tank2)
        
    }
    
    func createButtons() {
        self.leftButton = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
        self.leftButton.position = CGPoint(x: self.size.width/2 - 100, y: 200)
        self.leftButton.name = "leftButton"
        self.leftButton.fillColor = UIColor(named: "lightGreen")!
        
        self.rightButton = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
        self.rightButton.position = CGPoint(x: self.size.width/2 + 100, y: 200)
        self.rightButton.name = "rightButton"
        self.rightButton.fillColor = UIColor(named: "lightGreen")!
        
        self.addChild(self.leftButton)
        self.addChild(self.rightButton)
    }
    
    func placeTank(tank: SKShapeNode) {
        if tankFactory.iHaveMadeSoManyTanks == 1 {
            tank.position = CGPoint(x: 100 + tank.frame.width/2,y: 300 + tank.frame.height/2)
        } else if tankFactory.iHaveMadeSoManyTanks == 2 {
            tank.position = CGPoint(x: self.frame.width - 100 - tank.frame.width/2,y: 300 + tank.frame.height/2)
        }
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
    }

    
    //Create player area with bounderies, together with physics
    func createArea() {
        self.scene?.anchorPoint = CGPoint(x: 0, y: 0)
        self.backgroundColor = UIColor(named: "skyBlue")!
        self.scaleMode = .aspectFill
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = CGFloat(0)
        self.physicsBody?.restitution = CGFloat(0)
        self.physicsBody?.angularDamping = CGFloat(0)
        self.physicsBody?.linearDamping = CGFloat(0)
        self.physicsBody!.categoryBitMask = PhysicsCategory.Edge
        self.physicsBody!.collisionBitMask = PhysicsCategory.Tank
        self.physicsBody?.isDynamic = false
        
        self.width = self.frame.width
        self.height = self.frame.height
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    //Listener for when touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "leftButton" {
                print("leftButton touched")
                tank1.position = CGPoint(x: 100 + tank1.frame.width/2,y: 300 + tank1.frame.height/2)
            } else if name == "rightButton" {
                print("rightButton touched")
                tank2.position = CGPoint(x: self.frame.width - tank2.frame.width/2 - 100 ,y: 300 + tank2.frame.height/2)
            }
        }
        
    }
    
    //Listener for when touch in progress
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    

}



