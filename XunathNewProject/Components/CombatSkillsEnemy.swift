//
//  CombatSkillsEnemy.swift
//  Xunath
//
//  Created by Paulo César on 26/10/22.
//

import Foundation
import SpriteKit

protocol CombatSkillsEnemy {
    func commonAttack(target: MainCharacter) -> Int
    func takeDamage(dmg: Int) -> Bool
}

extension CombatSkillsEnemy where Self: Enemy {
    func commonAttack(target: MainCharacter) -> Int {
        let damage: Int = (attack) - (target.defense / 2)
        return damage
    }
    
    func takeDamage(dmg: Int) -> Bool {
        self.currentHealth -= dmg
        
        if self.currentHealth <= 0 {
            self.defeat()
            return true
        }
        return false
    }
    
    func defeat() {
        self.hasBeenDefeated = true
        self.combatSprite.run(.sequence([.fadeAlpha(to: 0, duration:  2.5),
                                         .removeFromParent()]))
    }
}
