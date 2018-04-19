//
//  Canon.swift
//  Tankz
//
//  Created by Clas Olaf Steinbru Andersen on 19.04.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class Canon: SKShapeNode {
    private let length: CGFloat
    private let width: CGFloat
    private var currentAngle: CGFloat
    
    init(canonType: CanonType){
        switch canonType{
            case .small:
                self.length = 150
                self.width = 25
                self.currentAngle = 45
            case .big:
                self.length = 150
                self.width = 25
                self.currentAngle = 45
            case .funny:
                self.length = 150
                self.width = 25
                self.currentAngle = 45
        }
        super.init()
        self.initShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate(angle: CGFloat){
        let currentRadAngle = self.currentAngle * CGFloat(Double.pi) / 180
        let radAngle = angle * CGFloat(Double.pi) / 180
        self.run(SKAction.rotate(byAngle: currentRadAngle - radAngle, duration: 0.5))
        self.currentAngle = angle
    }
    
    /* Get Functions */
    func getCurrentAngle() -> CGFloat {
        return self.currentAngle
    }
    
    func getCanonOpening() -> CGPoint{
        let radAngle = self.currentAngle * CGFloat(Double.pi) / 180
        let xValue = self.position.x + (self.length - (self.width / 2)) * cos(radAngle)
        let yValue = self.position.y + (self.length - (self.width / 2)) * sin(radAngle)
        return CGPoint(x: xValue, y: yValue)
    }
    
    /* Helper Functions*/
    private func initShape(){
        let origin = CGPoint(x: self.width/2 * -1, y: self.width/2 * -1)
        let size = CGSize(width: self.width, height: self.length)
        self.path = CGPath(rect: CGRect(origin: origin, size: size), transform: nil)
        self.fillColor = UIColor.black
        self.strokeColor = UIColor.black
        let radAngle = self.currentAngle * CGFloat(Double.pi) / 180
        self.run(SKAction.rotate(toAngle: radAngle, duration: 0))
    }
}
