//
//  Keybinds.swift
//  Macro
//
//  Created by Paulo César on 13/09/22.
//

// swiftlint: disable identifier_name

import Foundation

enum WalkKeybinds: UInt16, CaseIterable {
    case UP = 0x7E
    case ALTERNATIVEUP = 0xD
    case DOWN = 0x7D
    case ALTERNATIVEDOWN = 0x1
    case LEFT = 0x7B
    case ALTERNATIVELEFT = 0x0
    case RIGHT = 0x7C
    case ALTERNATIVERIGHT = 0x2    
}

enum InteractKeybinds: UInt16, CaseIterable {
    case INTERACT = 0x6
    case ALTERNATIVEINTERACT = 0x2E
}

enum CombatKeybinds: UInt16 {
    case ATTACK = 0x0
    case HEAL = 0x1
    case FLEE = 0x2
}

enum AttackKeybinds: UInt16 {
    case FOCUSPUNCH = 0x0
    case CORRUPTION = 0x1
    case DESTRUCTION = 0x2
    case ILLUSION = 0x3
    case BACK = 0x5
}


