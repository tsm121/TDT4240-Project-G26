//
//  MapFactory.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

class MapFactory {
    
    let width : CGFloat
    
    init(skSceneWidth: CGFloat) {
        self.width = skSceneWidth
    }
    
    func makeMap(mapType: MapType) -> Map {
        return Map(mapType: mapType, width: self.width)
    }

}
