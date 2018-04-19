//
//  Explosion.swift
//  Tankz
//
//  Created by Clas Olaf Steinbru Andersen on 17.04.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//
import SpriteKit

class Explosion : SKSpriteNode{
    let explosionFrames : [SKTexture]
    
    init(){
        
        // Create Explosion Frames
        let explosionAnimatedAtlas = SKTextureAtlas(named: "explosion.atlas")
        var explosionFrames: [SKTexture] = []
        for i in 1...explosionAnimatedAtlas.textureNames.count {
            let explosionTextureName = "boom\(i)"
            explosionFrames.append(explosionAnimatedAtlas.textureNamed(explosionTextureName))
        }
        self.explosionFrames = explosionFrames
        // Super init
        let texture = SKTexture(imageNamed: "boom1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.scale(to: CGSize(width: 50, height: 50))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func explode(){
        self.run(
            SKAction.animate(
                with: self.explosionFrames,
                timePerFrame: 0.075,
                resize: false,
                restore: true)
            , completion: {
                self.removeFromParent()

            }
        );
    }
}
/*class AmmoExplosion {
 init() {
 
 explosion.position = liveAmmoPosition

 }*/
