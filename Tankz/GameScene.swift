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
    private var explosion : Explosion!
    private var height : CGFloat!
    private var width : CGFloat!

    private var chosenAmmo : AmmoType = .missile
    public var currentTank : Tank!

    private var touchDownPos : CGPoint!
    private var prevMove: (SKAction, String)?
    private var lastMove: (SKAction, String)?


    private var leftButton : SKShapeNode!
    private var rightButton : SKShapeNode!
    
    private var terrain : MapType!
    
    public var healthBar1 = SKSpriteNode()
    public var healthBar2 = SKSpriteNode()

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
        tank1 = tankFactory.makeTank(tanktype: .bigTank, tankName: "Player 1", color: UIColor.black, tankdirection: TankDirection.right)
        placeTank(tankBody: tank1.body)
        tank2 = tankFactory.makeTank(tanktype: .funnyTank, tankName: "Player 2", color: UIColor.black, tankdirection: TankDirection.left)
        placeTank(tankBody: tank2.body)

        currentTank = tank1
        ammoFactory = AmmoFactory()

        self.addChild(tank1.body)
        self.addChild(tank2.body)
        
        // Prepare Explosions
        self.explosion = Explosion();
        
        // Add healthbars
        
        healthBar1.position = CGPoint(x: tank1.body.position.x, y: tank1.body.position.y + 20)
        healthBar2.position = CGPoint(x: tank2.body.position.x, y: tank2.body.position.y + 20)
        
        self.addChild(healthBar1)
        self.addChild(healthBar2)
        
        updateHealthBar(node: healthBar1, health: tank1.health - tank1.damageTaken, maxHealth: tank1.health)
        updateHealthBar(node: healthBar2, health: tank2.health - tank2.damageTaken, maxHealth: tank2.health)
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
        
        self.scene?.anchorPoint = CGPoint(x: 0, y: 0)
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
        healthBar1.position = CGPoint(x: tank1.body.position.x, y: tank1.body.position.y + 20)
        healthBar2.position = CGPoint(x: tank2.body.position.x, y: tank2.body.position.y + 20)
    }
    
    func updateHealthBar(node: SKSpriteNode, health: Double, maxHealth: Double){
        let barSize = CGSize(width: 100, height: 20)
        let fillColor = UIColor(red: 113/255, green: 202/255, blue: 53/255, alpha: 1)
        let borderColor = UIColor(red: 35/255, green: 28/255, blue: 40/255, alpha: 1)
    
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPoint(x: 0, y: 0), size: barSize)
        context!.stroke(borderRect, width: 1)
        
        fillColor.setFill()
        let barWidth = (barSize.width - 1) * CGFloat(health) / CGFloat(maxHealth)
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        context!.fill(barRect)
        
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        node.texture = SKTexture(image: spriteImage!)
        node.size = barSize
    }

    func didBegin(_ contact: SKPhysicsContact) {

        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        //If projectile hits something in its contactTestBitMask
        if(firstBody.categoryBitMask == PhysicsCategory.Projectile || secondBody.categoryBitMask == PhysicsCategory.Projectile) {
            print("Projectile hit something")
            liveAmmo.projectile.run(SKAction.removeFromParent()) //deletes ammo on hit
            self.explosion.explode(position: contact.contactPoint, parent: self)
        }

        //If projectile hits a tank.
        if((firstBody.categoryBitMask == PhysicsCategory.Tank && secondBody.categoryBitMask == PhysicsCategory.Projectile) ||
            (firstBody.categoryBitMask == PhysicsCategory.Projectile && secondBody.categoryBitMask == PhysicsCategory.Tank)) {
            print("Projectile hit a tank")

            if(firstBody == tank1.body.physicsBody || secondBody == tank1.body.physicsBody) { // If tank1 was hit.
                tank1.damageTaken = tank1.damageTaken + liveAmmo.damage
                updateHealthBar(node: healthBar1, health: tank1.health - tank1.damageTaken, maxHealth: tank1.health) // Update healthbar.
                //print("tank1 took damage, health: ", tank1.health - tank1.damageTaken,"/",tank1.health)
                if (tank1.health - tank1.damageTaken < 0) { // If tank1 exploded
                    tank1.body.run(SKAction.removeFromParent())
                    print("tank1 exploded.")
                    self.viewController.gameHasEnded()
                    
                }
            }

            if(firstBody == tank2.body.physicsBody || secondBody == tank2.body.physicsBody) { // If tank2 was hit.
                tank2.damageTaken = tank2.damageTaken + liveAmmo.damage
                updateHealthBar(node: healthBar2, health: tank2.health - tank2.damageTaken, maxHealth: tank2.health)
                //print("tank2 took damage, health: ", tank2.health - tank2.damageTaken,"/",tank2.health)
                if (tank2.health - tank2.damageTaken < 0) { //If tank2 exploded.
                    tank2.body.run(SKAction.removeFromParent())
                    print("tank2 exploded.")
                    self.viewController.gameHasEnded()
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
