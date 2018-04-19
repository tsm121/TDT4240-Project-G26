//
//  HealthBar.swift
//  Tankz
//
//  Created by Nikolai on 18/04/2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit


class HealthBar: SKSpriteNode {
    
    public let maxHealth: Double
    
    init(position: CGPoint, maxHealth: Double) {
        self.maxHealth = maxHealth
        super.init(texture: nil, color: UIColor.clear, size: CGSize.zero)
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHealthBar(health: Double){
        let barSize = CGSize(width: 50, height: 10)
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
        
        self.texture = SKTexture(image: spriteImage!)
        self.size = barSize
    }
}
