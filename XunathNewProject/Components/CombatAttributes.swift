//
//  CombatAttributes.swift
//  Macro
//
//  Created by Paulo César on 17/10/22.
//

import Foundation
import SpriteKit

protocol CombatAttributes {
    var maxHealth: Int { get set }
    var currentHealth: Int { get set }
    var maxMana: Int { get set }
    var currentMana: Int { get set }
    var attack: Int { get set }
    var defense: Int { get set }
    var agility: Int { get set }
    
    var maxExperience: Int { get set }
    var currentExperience: Int { get set }
    var level: Int { get set }
}
