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
    public var currentTank : Tank!
    
    private var touchDownPos : CGPoint!
    private var prevMove: (SKAction, String)?
    private var lastMove: (SKAction, String)?

    
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
        
        currentTank = tank1
        ammoFactory = AmmoFactory()
        
        self.addChild(tank1.body)
        self.addChild(tank2.body)
                
    }
    

    //TODO: Not done, does not evaluate given data
    /**
     Recieves opponent action data from the Multiplayer service.
     Evaluates the given information and performes these action for the users.
     - Parameters:
        - fireVector: `CGVector`, the vector that the opponent used
        - ammoType: `AmmoType`, the `AmmoType` that the opponent used
        - moveAction: (`SkAction`, `String`), tuple of opponent move action with action and direction-key.
     */
    public func gameListener(fireVector: CGVector, ammoType: AmmoType, moveAction: (SKAction, String)) {
        
        //Run opponent move
        self.moveOppTank(move: moveAction)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            //Run opponent shot
            self.fire(ammoType: ammoType, fireVector: fireVector, tank: self.currentTank)
            print("Opponent shoots")
        }
        
        //Give user controls
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.userTurn()
        }
    }
    
    //Temp func (should be a listner)
    /**
     Get called on upon by `gameListener()` when the opponent action has been performed.
     Enables the controls so that the user can perform his/hers turn.
     */
    func userTurn() {
        //Enable controls for this unit
        self.viewController.enableControls()
        //Do actions
    }
    
    //TODO: Tell Multiplayer-class your actions
    /**
     Get called on upon by  `GameViewController`'s `fireAction()` when the user has pressed the `UIButton` for fire.
     Disable user controls and resets the last moves done.
     */
    public func finishTurn() {
        self.viewController.disableControls()
        
        //Send information to opponent
        //Reset information
        self.prevMove = self.lastMove
        self.lastMove = nil
        
    }
    
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
        if self.currentTank.hasFuel() {
            if self.currentTank.body.action(forKey: "moveLeft") == nil {
                if self.currentTank.fuel > 0 {
                    self.currentTank.body.run(SKAction.sequence([self.currentTank.moveLeft]), withKey:"moveLeft")
                    self.currentTank.useFuel()
                    self.viewController.setFuelLabel()
                    self.prevMove = self.lastMove
                    self.lastMove = (self.currentTank.moveLeft, "moveLeft")
                }
            }
        }
    }
    
    /**
     Moves users `Tank` to the right with a `SKAction` and set `prevMove` and `lastMove`.
     */
    public func moveTankRight() {
        if self.currentTank.hasFuel() {
            if self.currentTank.body.action(forKey: "moveRight") == nil {
                if self.currentTank.fuel > 0 {
                    self.currentTank.body.run(SKAction.sequence([self.currentTank.moveRight]), withKey:"moveRight")
                    self.currentTank.useFuel()
                    self.viewController.setFuelLabel()
                    self.prevMove = self.lastMove
                    self.lastMove = (self.currentTank.moveRight, "moveRight")
                }
            }
        }
    }
    
    /**
     Moves opponent `Tank` to the given position.
     - Parameters:
        - move: the given `SKAction` and direction-key
     */
    public func moveOppTank(move:(SKAction, String)) {
        if self.tank2.body.action(forKey: move.1) == nil {
            self.tank2.body.run(move.0, withKey: move.1)
        }
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
    
    func fire(ammoType: AmmoType, fireVector: CGVector, tank: Tank){ //Arguments might not be needed
        self.liveAmmo = ammoFactory.makeAmmo(ammotype: ammoType)
        self.liveAmmo.projectile.position = CGPoint(x: tank.body.position.x , y: tank.body.position.y + 10)
        self.liveAmmo.projectile.physicsBody?.velocity = fireVector
        self.addChild(self.liveAmmo.projectile)
        nextTurn()
        
        //let deleteAmmo = ammo.run(SKAction.removeFromParent()) //to delete ammo on hit
    }
    
    func nextTurn() {
        if (tank1.body.name?.isEqual(currentTank.body.name))! {
            currentTank = tank2
        } else {
            currentTank = tank1
        }
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
        fire(ammoType: self.chosenAmmo, fireVector: fireVector, tank: self.currentTank)
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



