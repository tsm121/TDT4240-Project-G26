//
//  HealthBar.swift
//  Tankz
//
//  Created by Nikolai on 18/04/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit


class HealthBar: SKSpriteNode {
    
    public let maxHealth: CGFloat
    
    init(maxHealth: CGFloat) {
        self.maxHealth = maxHealth
        super.init(texture: nil, color: UIColor.clear, size: CGSize.zero)
        self.size = CGSize(width: 250, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHealthBar(health: CGFloat){
        
        let fillColor : UIColor!
        
        if health/self.maxHealth < 0.4 {
            fillColor = UIColor.red
        } else if health/self.maxHealth < 0.6 {
            fillColor = UIColor.orange
        } else {
            fillColor = UIColor(red: 113/255, green: 202/255, blue: 53/255, alpha: 1)
        }
        
        let borderColor = UIColor(red: 35/255, green: 28/255, blue: 40/255, alpha: 1)
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        
        fillColor.setFill()
        let barWidth = (self.size.width - 1) * CGFloat(health) / CGFloat(maxHealth)
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: self.size.height - 1)
        context!.fill(barRect)
        context!.stroke(borderRect, width: 25)
        
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.texture = SKTexture(image: spriteImage!)
    }
}

