//
//  PhysicsCategory.swift
//  Tankz
//
//  Created by Martin Langmo Karlstrøm on 09.03.2018.
//  Copyright © 2018 TDT4240-Group26. All rights reserved.
//


// Sets different physicscategories for different objects.
struct PhysicsCategory {
    static let None:        UInt32 = 0      //  0
    static let Edge:        UInt32 = 0b1    //  1
    static let Projectile:  UInt32 = 0b10   //  2
    static let Tank:        UInt32 = 0b100  //  4
    static let Ground:      UInt32 = 0b1000 // 5
}
