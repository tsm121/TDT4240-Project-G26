//
//  GameScene.swift
//  Tankz
//
//  Created by Thomas Markussen on 05/03/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var viewController: GameViewController!
    
    private var tankFactory : TankFactory!
    private var mapFactory : MapFactory!
    private var ammoFactory : AmmoFactory!
    public var tank1 : Tank!
    public var tank2 : Tank!
    private var map : Map!
    private var liveAmmo : Ammo!
    private var height : CGFloat!
    private var width : CGFloat!
    
    private var chosenAmmo : AmmoType = .missile
    
    private var touchDownPos : CGPoint!
    
    private var leftButton : SKShapeNode!
    private var rightButton : SKShapeNode!

    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // Create game area, full screen.
        self.createArea()
        
        // Generate the world map.
        mapFactory = MapFactory(skSceneWidth: CGFloat(self.size.width))
        map = mapFactory.makeMap(mapType: .flat)
        self.addChild(map.ground)
        
        
        // Generate a tank from the factory.
        tankFactory = TankFactory()
        tank1 = tankFactory.makeTank(tanktype: .bigTank, tankName: "Player 1", color: UIColor(named: "militaryGreenLight")!)
        placeTank(tankBody: tank1.body)
        tank2 = tankFactory.makeTank(tanktype: .funnyTank, tankName: "Player 2", color: UIColor(named: "militaryGreenDark")!)
        placeTank(tankBody: tank2.body)
        
        ammoFactory = AmmoFactory()
        
        self.addChild(tank1.body)
        self.addChild(tank2.body)
        
    }
    
    func setTankPos(){
        self.tank1.body.position = CGPoint(x: 100, y: 500)
    }
    
    
    func placeTank(tankBody: SKShapeNode) {
        if tankFactory.iHaveMadeSoManyTanks == 1 {
            tankBody.position = CGPoint(x: 100 + tankBody.frame.width/2,y: 300 + tankBody.frame.height/2)
        } else if tankFactory.iHaveMadeSoManyTanks == 2 {
            tankBody.position = CGPoint(x: self.frame.width - 100 - tankBody.frame.width/2,y: 300 + tankBody.frame.height/2)
        }
    }
    
    func fire(ammoType: AmmoType, tank: Tank, fireVector: CGVector){ //Arguments might not be needed
        self.liveAmmo = ammoFactory.makeAmmo(ammotype: ammoType)
        self.liveAmmo.projectile.position = CGPoint(x: self.tank1.body.position.x , y: self.tank1.body.position.y + 10)
        self.liveAmmo.projectile.physicsBody?.velocity = fireVector
        self.addChild(self.liveAmmo.projectile)
        
        
        //let deleteAmmo = ammo.run(SKAction.removeFromParent()) //to delete ammo on hit
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
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        self.touchDownPos = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let xDrag = self.touchDownPos.x - pos.x
        let yDrag = self.touchDownPos.y - pos.y
        let scale = CGFloat(4)
        let fireVector = CGVector(dx: xDrag * scale, dy: yDrag * scale)
        fire(ammoType: self.chosenAmmo, tank: tank1, fireVector: fireVector)
    }
    
    //Listener for when touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        
        if let name = touchedNode.name {
            if name == "leftButton" {
                if self.tank1.body.action(forKey: "moveLeft") == nil { // check that there's no action running
                    let moveLeft = SKAction.moveBy(x: -20, y: 5, duration: 0.5)
                    self.tank1.body.run(SKAction.sequence([moveLeft]), withKey:"moveLeft")
                }
            } else if name == "rightButton" {
                if self.tank1.body.action(forKey: "moveRight") == nil { // check that there's no action running
                    let moveRight = SKAction.moveBy(x: 20, y: 5, duration: 0.5)
                    self.tank1.body.run(SKAction.sequence([moveRight]), withKey:"moveRight")
                }
            } else {
                self.touchDown(atPoint: positionInScene)
            }
        }
        
    }
    
    //Listener for when touch in progress
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        self.touchUp(atPoint: touch.location(in: self))
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
}



