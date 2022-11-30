//
//  BitMasks.swift
//  Macro
//
//  Created by Gabriel do Prado Moreira on 22/09/22.
//

import Foundation

enum BitMasks: UInt32 {
    case player = 0b1
    case enemy = 0b10
    case enemyVision = 0b100
    case wall = 0b1000
    case interactable = 0b10001
    case collectable = 0b100000
    case endBlock = 0b1000000
    case savePortal = 0b0101
    case designWall = 0b0000
    case ladder = 0b00110
}
