//
//  Tank.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 09.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit


class Tank : SKSpriteNode {
    /* Childe Nodes */
    private let canon: Canon
    private let healthBar: HealthBar
    /* Health Variables */
    private let maxHealth: CGFloat
    private var currentHealth: CGFloat
    /* Fuel Variables */
    private let maxFuel: CGFloat
    private var currentFuel: CGFloat
    /* Engine Variables */
    private let movementSpeed: CGFloat // In pixels per fuel
    /* Owner Variables */
    private let ownerIsHost: Bool
    /* Position */
    private var currentPosition: CGFloat?
    /* Ammo type */
    private var ammoType: AmmoType!
    
    
    init (ofType tankType: TankType, forHost: Bool){
        /* Setting Tank only Variables */
        let texture: SKTexture
        switch tankType {
            case .heavyTank:
                texture = SKTexture(imageNamed: forHost ? "tank1_p1" : "tank1_p2")
                self.maxHealth = 200
                self.currentHealth = 200
                self.maxFuel = 10
                self.currentFuel = 10
                self.movementSpeed = 20
                
                self.ammoType = .rocket
                self.canon = Canon(canonType: CanonType.heavy)
            
            case .mediumTank:
                texture = SKTexture(imageNamed: forHost ? "tank2_p1" : "tank2_p2")
                self.maxHealth = 150
                self.currentHealth = 150
                self.maxFuel = 15
                self.currentFuel = 15
                self.movementSpeed = 20
                
                self.ammoType = .mortar
                self.canon = Canon(canonType: CanonType.medium)
            
            case .lightTank:
                texture = SKTexture(imageNamed: forHost ? "tank3_p1" : "tank3_p2")
                self.maxHealth = 100
                self.currentHealth = 100
                self.maxFuel = 20
                self.currentFuel = 20
                self.movementSpeed = 20
                
                self.ammoType = .missile
                self.canon = Canon(canonType: CanonType.light)
        }
        
        
        
        self.ownerIsHost = forHost
        
        
        self.healthBar = HealthBar(maxHealth: self.maxHealth)
        
        /* Performing Super Init */
        super.init(
            texture: texture,
            color: UIColor.white.withAlphaComponent(0.0),
            size: texture.size())
        /* Setting SKSpriteNodeVariables */
        self.initPhysicsBody()
        self.xScale = self.ownerIsHost ? self.xScale * -0.25 : self.xScale * 0.25
        self.yScale = self.yScale * 0.25
        /* Position and Add Children */
        self.canon.position = self.position
        self.addChild(self.canon)
        self.healthBar.position.x = self.position.x
        self.healthBar.position.y = self.position.y + self.size.height/self.yScale + 50
        self.addChild(self.healthBar)
        self.healthBar.updateHealthBar(health: self.currentHealth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /* Game Functions */
    public func moveLeft(){
        if let currentPosition = self.currentPosition {}
        else { self.currentPosition = self.position.x }
        if (self.currentPosition! - self.frame.width/2 - self.movementSpeed - 20 > 0) {
            let currentPos = self.currentPosition == nil ? self.position.x : self.currentPosition
            let movSpeed = self.movementSpeed
            
            if currentFuel > 0 {
                self.currentFuel -= 1
                self.currentPosition! = currentPos! - movSpeed
                self.run(SKAction.moveTo(x: self.currentPosition!, duration: 0.1*Double(abs(self.position.x-self.currentPosition!))))
            }
        }
    }
    
    public func moveRight(){
        if let currentPosition = self.currentPosition {}
        else { self.currentPosition = self.position.x }
        if (self.currentPosition! + self.frame.width/2 + self.movementSpeed + 20 < (self.parent?.frame.width)! ){
            let currentPos = self.currentPosition == nil ? self.position.x : self.currentPosition
        
            let movSpeed = self.movementSpeed
        
            if currentFuel > 0 {
                self.currentFuel -= 1
                self.currentPosition? = currentPos! + movSpeed
                self.run(SKAction.moveTo(x: currentPos! + movSpeed, duration: 0.5))
            }
        }
    }


    public func fire(power: Float, angle: Float){
        let ammo = Ammo(ammoType: self.ammoType)
        let xDirection = CGFloat(-1 * self.xScale / abs(self.xScale))
        let canonOpening = self.canon.getCanonOpening()
        let canonRotation = self.canon.getCurrentAngle() * CGFloat(Double.pi) / 180
        let tankRotation = self.zRotation * xDirection
        print(canonRotation,"tank",tankRotation)
        let xPower = CGFloat(cos(canonRotation+tankRotation) * CGFloat(power * 15 + 150))
        let yPower = CGFloat(sin(canonRotation+tankRotation) * CGFloat(power * 15 + 150))
        let velocityVector = CGVector(
            dx: xPower * xDirection,
            dy: yPower)

        ammo.position = CGPoint(
            x: self.position.x + canonOpening.x * self.xScale * (-1.0),
            y: self.position.y + canonOpening.y * self.yScale)
        self.parent?.addChild(ammo)
        ammo.physicsBody?.velocity = velocityVector
    }
    
    public func rotateCanon(angle: CGFloat){
        self.canon.rotate(angle: angle)
    }

    /* Collision Functions */
    public func isHit(ammo: Ammo){
        print(self.currentHealth)
        self.currentHealth -= CGFloat(ammo.damage)
        self.healthBar.updateHealthBar(health: self.currentHealth)
        if self.isDead() { self.removeFromParent() }
        print(self.currentHealth)
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
    
    public func getCurrentAngle() -> CGFloat {
        return canon.getCurrentAngle()
    }
    
    public func getAmmoType() -> AmmoType {
        return self.ammoType
    }
    
    /* Is Functions */
    public func isOwnerHost() -> Bool{
        return self.ownerIsHost
    }
    
    public func isDead() -> Bool{
        return self.currentHealth <= 0
    }
    
    public func isAlive() -> Bool{
        return self.currentHealth > 0
    }
    
    /* Helper Functions */
    private func initPhysicsBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.mass = 20
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.friction = 5.0
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.linearDamping = 1.0
        self.physicsBody?.angularDamping = 1.0
        self.physicsBody?.categoryBitMask = PhysicsCategory.Tank
        self.physicsBody?.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Projectile | PhysicsCategory.Tank | PhysicsCategory.Ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
}
