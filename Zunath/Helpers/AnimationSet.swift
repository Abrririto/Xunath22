//
//  AnimationSet.swift
//  Macro
//
//  Created by Paulo César on 07/10/22.
//

import Foundation
import SpriteKit

enum AnimationSet: String {
    case idle = "idle"
    case walk = "walk"
    case combat_idle = "combat_idle"
    case combat_attack = "combat_attack"
}

enum DamageAnimationSet: String {
    case focusPunch = "focuspunch"
    case destruction = "destruction"
    case illusion = "illusion"
    case corruption = "corruption"
}

enum AnimationDirection: String {
    case up = "up"
    case down = "down"
    case side = "side"
}
