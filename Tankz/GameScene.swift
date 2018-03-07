//
//  Pong 9000^69
//

import SpriteKit
import GameplayKit

enum TankType {
    case smallTank
    case bigTank
    case funnyTank
}

enum MapType {
    case flat
    case flatty
    case hills
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var tankFactory : TankFactory!
    private var mapFactory : MapFactory!
    private var tank : SKShapeNode!
    private var map : SKShapeNode!
    private var height : Double!
    private var width : Double!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // Create game area, full screen.
        self.createArea()
        
        // Generate the world map.
        mapFactory = MapFactory(skScene: self)
        map = mapFactory.makeMap(MapType: .hills)
        self.addChild(map)
        
        
        // Generate a tank from the factory.
        tankFactory = TankFactory(skScene: self)
        tank = tankFactory.makeTank(tanktype: .smallTank)
        self.addChild(tank)
        
    }
    
    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        
    }

    
    //Create player area with bounderies, together with physics
    func createArea() {
        self.scene?.anchorPoint = CGPoint(x: 0, y: 0)
        self.backgroundColor = UIColor.white
        self.scaleMode = .aspectFill
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = CGFloat(0)
        self.physicsBody?.restitution = CGFloat(0)
        self.physicsBody?.angularDamping = CGFloat(0)
        self.physicsBody?.linearDamping = CGFloat(0)
        self.physicsBody!.categoryBitMask = 0
        self.physicsBody?.isDynamic = false
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    //Listener for when touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    //Listener for when touch in progress
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    

}



