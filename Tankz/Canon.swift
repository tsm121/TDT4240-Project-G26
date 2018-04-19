//
//  Canon.swift
//  Tankz
//
//  Created by Clas Olaf Steinbru Andersen on 19.04.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class Canon: SKShapeNode {
    init(canonType: CanonType){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
