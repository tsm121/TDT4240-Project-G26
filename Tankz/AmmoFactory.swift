//
//  AmmoFactory.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 06.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

import SpriteKit

/*
 Ammo Factory.
 Redundant.
 */


class AmmoFactory {
    
    public func makeAmmo(ammotype: AmmoType) -> Ammo {
        return Ammo(ammoType: ammotype)
    }
    
}

