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
    
    private var myTurn: Bool?
    private var myTank: Tank?

    private var chosenAmmo : AmmoType = .missile
    public var currentTank : Tank!

    private var touchDownPos : CGPoint!
    private var prevMove: (SKAction, String)?
    private var lastMove: (SKAction, String)?


    private var leftButton : SKShapeNode!
    private var rightButton : SKShapeNode!
    
    private var terrain : MapType!


    override func didMove(to view: SKView) {

        physicsWorld.contactDelegate = self
        
        terrain = .mars


        // Create game area, full screen.
        self.createArea(terrain: terrain)

        // Generate the world map.
        mapFactory = MapFactory(skSceneWidth: CGFloat(self.size.width))
        map = mapFactory.makeMap(mapType: terrain)
        
        self.addChild(map.wallpaper)
        self.addChild(map.ground)
        

        // Generate a tank from the factory.
        tankFactory = TankFactory()
        let hostTank = Multiplayer.shared.player.isHost ? Multiplayer.shared.player.tank : Multiplayer.shared.opponent?.tank
        let clientTank = !Multiplayer.shared.player.isHost ? Multiplayer.shared.player.tank : Multiplayer.shared.opponent?.tank
        tank1 = tankFactory.makeTank(tankType: TankType(rawValue: hostTank!)!, forHost: true)
        placeTank(tankBody: tank1)
        tank2 = tankFactory.makeTank(tankType: TankType(rawValue: clientTank!)!, forHost: false)
        placeTank(tankBody: tank2)

        currentTank = tank1
        ammoFactory = AmmoFactory()

        self.addChild(tank1)
        self.addChild(tank2)

    }

    //TODO: Tell Multiplayer-class your actions
    /**
     Get called on upon by  `GameViewController`'s `fireAction()` when the user has pressed the `UIButton` for fire.
     Disable user controls and resets the last moves done.
     */

    /**
     Getter for users tank.
     - returns:
    `Tank`: Users tank
     */
    public func getMyTank() -> Tank{
        if (Multiplayer.shared.player.isHost){
            return self.tank1
        }
        return self.tank2
    }

    /**
     Moves users `Tank` to the left with a `SKAction` and set `prevMove` and `lastMove`.
     */
    public func moveTankLeft() {
        self.currentTank.moveLeft()
        self.viewController.setFuelLabel()
    }

    /**
     Moves users `Tank` to the right with a `SKAction` and set `prevMove` and `lastMove`.
     */
    public func moveTankRight() {
        self.currentTank.moveRight()
        self.viewController.setFuelLabel()
    }

    func setTankPos(){
        self.currentTank.position = CGPoint(x: 100, y: 500)
    }

    func placeTank(tankBody: SKSpriteNode) {
        if tankFactory.iHaveMadeSoManyTanks == 1 {
            tankBody.position = CGPoint(x: 100 + tankBody.frame.width/2,y: 300 + tankBody.frame.height/2)
        } else if tankFactory.iHaveMadeSoManyTanks == 2 {
            tankBody.position = CGPoint(x: self.frame.width - 100 - tankBody.frame.width/2,y: 300 + tankBody.frame.height/2)
        }
    }

    func fire(ammoType: AmmoType, power: Float, angle: Float){ //Arguments might not be needed
        if (self.getMyTank().isOwnerHost() == self.currentTank.isOwnerHost()) {
            self.viewController.disableControls()
        }
        currentTank.fire(ammoType: ammoType, power: power, angle: angle)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.nextTurn()
        }
    }

    func nextTurn() {
        if (self.currentTank.isOwnerHost()) {
            self.currentTank = tank2
        } else {
            self.currentTank = tank1
        }
        if (self.getMyTank().isOwnerHost() == self.currentTank.isOwnerHost()) {
            self.viewController.enableControls()
        }
    }


    // Create player area with bounderies, together with physics
    func createArea(terrain : MapType) {
        
        
        // Map colors for the sky.
        switch terrain {
        case .earth:
            self.backgroundColor = UIColor(named: "skyBlue")!
        case .mars:
            self.backgroundColor = UIColor(red: 227/255, green: 240/255, blue: 155/255, alpha: 1)
        case .moon:
            self.backgroundColor = UIColor(red: 20/255, green: 79/255, blue: 132/255, alpha: 1)
        }
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = CGFloat(0)
        self.physicsBody?.restitution = CGFloat(0)
        self.physicsBody?.angularDamping = CGFloat(0)
        self.physicsBody?.linearDamping = CGFloat(0)
        self.physicsBody!.categoryBitMask = PhysicsCategory.Edge
        self.physicsBody!.collisionBitMask = PhysicsCategory.Tank
        self.physicsBody?.isDynamic = false
    }

    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {

    }

    func didBegin(_ contact: SKPhysicsContact) {
        // Crash Happened
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        // Was a projectile Involved?
        if(firstBody.categoryBitMask == PhysicsCategory.Projectile || secondBody.categoryBitMask == PhysicsCategory.Projectile) {
            let ammo = firstBody.categoryBitMask == PhysicsCategory.Projectile ? firstBody.node as! Ammo : secondBody.node as! Ammo
            ammo.collided(position: contact.contactPoint)
            // Was a tank Involved?
            if(firstBody.categoryBitMask == PhysicsCategory.Tank && secondBody.categoryBitMask == PhysicsCategory.Tank) {
                let tank = firstBody.categoryBitMask == PhysicsCategory.Tank ? firstBody.node as! Tank : secondBody.node as! Tank
                tank.isHit(ammo: ammo)
                if (tank.isDead()){
                    self.viewController.gameHasEnded()
                }
            }
        }

        //If projectile hits a tank.
        
    }

    func touchDown(atPoint pos : CGPoint) {
        self.touchDownPos = pos
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
            } else if name == "rightButton" {
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
