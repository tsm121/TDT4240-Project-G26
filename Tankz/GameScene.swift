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
        tank1 = tankFactory.makeTank(tanktype: .bigTank, tankName: "Player 1", color: UIColor(named: "militaryGreenLight")!, tankdirection: TankDirection.right)
        placeTank(tankBody: tank1.body)
        tank2 = tankFactory.makeTank(tanktype: .funnyTank, tankName: "Player 2", color: UIColor(named: "militaryGreenDark")!, tankdirection: TankDirection.left)
        placeTank(tankBody: tank2.body)

        currentTank = tank1
        ammoFactory = AmmoFactory()

        self.addChild(tank1.body)
        self.addChild(tank2.body)

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

    func setTankPos(){
        self.currentTank.body.position = CGPoint(x: 100, y: 500)
    }

    func placeTank(tankBody: SKShapeNode) {
        if tankFactory.iHaveMadeSoManyTanks == 1 {
            tankBody.position = CGPoint(x: 100 + tankBody.frame.width/2,y: 300 + tankBody.frame.height/2)
        } else if tankFactory.iHaveMadeSoManyTanks == 2 {
            tankBody.position = CGPoint(x: self.frame.width - 100 - tankBody.frame.width/2,y: 300 + tankBody.frame.height/2)
        }
    }

    func fire(ammoType: AmmoType, power: Float, angle: Float){ //Arguments might not be needed
        let xValue = CGFloat(cos(Double(angle) * Double.pi / 180.0) * Double(power * 10))
        let yValue = CGFloat(sin(Double(angle) * Double.pi / 180.0) * Double(power * 10))
        if (self.getMyTank().body.name?.isEqual(currentTank.body.name))! {
            self.viewController.disableControls()
        }
        self.liveAmmo = ammoFactory.makeAmmo(ammotype: ammoType)
        self.liveAmmo.projectile.position = CGPoint(x: currentTank.body.position.x , y: currentTank.body.position.y + 10)
        self.liveAmmo.projectile.physicsBody?.velocity = CGVector(dx: xValue*CGFloat(currentTank.tankdirection.rawValue), dy: yValue)
        self.addChild(self.liveAmmo.projectile)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.nextTurn()
        }
    }

    func nextTurn() {
        if (tank1.body.name?.isEqual(currentTank.body.name))! {
            currentTank = tank2
        } else {
            currentTank = tank1
        }
        if (self.getMyTank().body.name?.isEqual(currentTank.body.name))! {
            self.viewController.enableControls()
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

    func didBegin(_ contact: SKPhysicsContact) {

        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        //If projectile hits something in its contactTestBitMask
        if(firstBody.categoryBitMask == PhysicsCategory.Projectile || secondBody.categoryBitMask == PhysicsCategory.Projectile) {
            print("Projectile hit something")
            liveAmmo.projectile.run(SKAction.removeFromParent()) //deletes ammo on hit
        }

        //If projectile hits a tank.
        if((firstBody.categoryBitMask == PhysicsCategory.Tank && secondBody.categoryBitMask == PhysicsCategory.Projectile) ||
            (firstBody.categoryBitMask == PhysicsCategory.Projectile && secondBody.categoryBitMask == PhysicsCategory.Tank)) {
            print("Projectile hit a tank")

            if(firstBody == tank1.body.physicsBody || secondBody == tank1.body.physicsBody) { // If tank1 was hit.
                tank1.damageTaken = tank1.damageTaken + liveAmmo.damage
                print("tank1 took damage, health: ", tank1.health - tank1.damageTaken,"/",tank1.health)
                if (tank1.health - tank1.damageTaken < 0) { // If tank1 exploded
                    tank1.body.run(SKAction.removeFromParent())
                    print("tank1 exploded.")
                }
            }

            if(firstBody == tank2.body.physicsBody || secondBody == tank2.body.physicsBody) { // If tank2 was hit.
                tank2.damageTaken = tank2.damageTaken + liveAmmo.damage
                print("tank2 took damage, health: ", tank2.health - tank2.damageTaken,"/",tank2.health)
                if (tank2.health - tank2.damageTaken < 0) { //If tank2 exploded.
                    tank2.body.run(SKAction.removeFromParent())
                    print("tank2 exploded.")
                }
            }
        }
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
