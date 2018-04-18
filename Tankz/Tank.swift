//
//  Tank.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 09.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

/*class Tank {
    public let body: SKSpriteNode
    public var health: Double
    public var damageTaken: Double
    public let mass: CGFloat
    public let size: CGSize
    public var fuel: Int
    public let moveRight: SKAction
    public let moveLeft: SKAction
    public let tankdirection: TankDirection
    
    init(tankType: TankType, tankName: String, color: UIColor, tankdirection: TankDirection) {
        switch tankType {
        case .smallTank:
            self.size = CGSize(width: 10, height: 5)
            self.mass = 10.0
            self.health = 100.0
            self.damageTaken = 0.0
            self.fuel = 20
            self.moveRight = SKAction.moveBy(x: 20, y: 5, duration: 0.5)
            self.moveLeft = SKAction.moveBy(x: -20, y: 5, duration: 0.5)
        case .bigTank:
            self.size = CGSize(width: 20, height: 10)
            self.mass = 20.0
            self.health = 200.0
            self.damageTaken = 0.0
            self.fuel = 10
            self.moveRight = SKAction.moveBy(x: 10, y: 5, duration: 0.5)
            self.moveLeft = SKAction.moveBy(x: -10, y: 5, duration: 0.5)
        case .funnyTank:
            self.size = CGSize(width: 15, height: 15)
            self.mass = 15.0
            self.health = 284.0
            self.damageTaken = 196.0
            self.fuel = 15
            self.moveRight = SKAction.moveBy(x: 20, y: 5, duration: 0.1)
            self.moveLeft = SKAction.moveBy(x: -20, y: 5, duration: 0.1)
        }
        self.tankdirection = tankdirection
        
        self.body = SKSpriteNode(imageNamed: "tank1_p1")
        self.body.size.height = self.body.size.height * 0.10
        self.body.size.width = self.body.size.width * 0.10
        self.body.physicsBody = SKPhysicsBody(rectangleOf: self.body.size)
        self.body.name = tankName
        self.body.physicsBody?.mass = self.mass
        self.body.physicsBody?.affectedByGravity = true
        self.body.physicsBody?.friction = 1.0
        self.body.physicsBody?.restitution = 0.0
        self.body.physicsBody?.linearDamping = 1.0
        self.body.physicsBody?.angularDamping = 1.0
        self.body.physicsBody!.categoryBitMask = PhysicsCategory.Tank
        self.body.physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Projectile | PhysicsCategory.Tank | PhysicsCategory.Ground
        self.body.physicsBody!.contactTestBitMask = PhysicsCategory.Projectile
        self.body.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    public func useFuel() {
        self.fuel -= 1
    }
    
    public func hasFuel() -> Bool {
        if self.fuel >= 1 {
            return true
        } else {return false}
    }
}*/

class Tank : SKSpriteNode {
    /* Health Variables */
    private let maxHealth: CGFloat
    private var currentHealth: CGFloat
    /* Fuel Variables */
    private let maxFuel: CGFloat
    private var currentFuel: CGFloat
    /* Engine Variables */
    private let movementSpeed: CGFloat // In pixels per fuel
    /* Canon Variables */
    private let maxAngle: CGFloat
    private let currentAngle: CGFloat
    private let minAngle: CGFloat
    private let minPower: CGFloat
    private let currentPower: CGFloat
    private let maxPower: CGFloat
    /* Owner Variables */
    private let ownerIsHost: Bool
    
    
    init (ofType: TankType, forHost: Bool){
        /* Setting Tank only Variables */
        let texture = SKTexture(imageNamed: "tank1_p1")
        self.maxHealth = 50
        self.currentHealth = 50
        self.maxFuel = 10
        self.currentFuel = 10
        self.movementSpeed = 20
        
        // TODO: Angle and Power need to be set to Real Values
        self.maxAngle = 180.0
        self.currentAngle = 180.0
        self.minAngle = 180.0
        self.minPower = 180.0
        self.currentPower = 180.0
        self.maxPower = 180.0
        
        self.ownerIsHost = forHost
        
        /* Performing Super Init */
        super.init(
            texture: texture,
            color: UIColor.white.withAlphaComponent(0.0),
            size: texture.size())
        
        /* Setting SKSpriteNodeVariables */
        self.xScale = self.ownerIsHost ? self.xScale * -1 * 0.1 : self.xScale * 0.1
        self.yScale = self.yScale * 0.1
        self.initSKPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /* Game Functions */
    public func moveLeft(){
        self.currentFuel -= 1
        self.run(SKAction.moveTo(x: self.position.x - self.movementSpeed, duration: 0.5))
    }
    
    public func moveRight(){
        self.currentFuel -= 1
        self.run(SKAction.moveTo(x: self.position.x + self.movementSpeed, duration: 0.5))
    }
    
    public func isHit(ammo: Ammo) -> Bool{
        self.currentHealth -= CGFloat(ammo.damage)
        return self.currentHealth <= 0 ? true : false
    }
    
    /* Get Functions */
    public func getMaxHealth() -> CGFloat {
        return self.maxHealth
    }
    
    public func getCurrentHealth() -> CGFloat {
        return self.currentHealth
    }
    
    public func getMaxFuel() -> CGFloat {
        return self.maxFuel
    }
    
    public func getCurrentFuel() -> CGFloat {
        return self.currentFuel
    }
    
    public func getMaxAngle() -> CGFloat {
        return self.maxAngle
    }
    
    public func getCurrentAngle() -> CGFloat {
        return self.currentAngle
    }
    
    public func getMinAngle() -> CGFloat {
        return self.minAngle
    }
    
    public func getMaxPower() -> CGFloat {
        return self.maxPower
    }
    
    public func getCurrentPower() -> CGFloat {
        return self.currentPower
    }
    
    public func getMinPower() -> CGFloat {
        return self.minPower
    }
    
    /* Is Functions */
    public func isOwnerHost() -> Bool{
        return self.ownerIsHost
    }
    
    /* Helper Functions */
    private func initSKPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.mass = 20
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.friction = 1.0
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.linearDamping = 1.0
        self.physicsBody?.angularDamping = 1.0
        self.physicsBody?.categoryBitMask = PhysicsCategory.Tank
        self.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Projectile | PhysicsCategory.Tank | PhysicsCategory.Ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
}
