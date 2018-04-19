//
//  enums.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 09.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//

// Tank types.
enum TankType: Int{
    case mediumTank = 0
    case lightTank = 1
    case heavyTank = 2
}

// Map types.
enum MapType: Int {
    case earth = 0
    case moon = 1
    case mars = 2
}


// Ammo types.
enum AmmoType {
    case missile
    case clusterBomb
    case funnyBomb
}

// Canon types.
enum CanonType {
    case small
    case big
    case funny
}

