//
//  CombatSkillsPlayer.swift
//  Xunath
//
//  Created by Paulo César on 26/10/22.
//

import Foundation
import SpriteKit

enum PlayerAggressiveSkills {
    case focusPunch
    case eruption
}

enum PlayerAllSkills {
    case focusPunch
    case eruption
    case healing
}

protocol CombatSkillsPlayer {
    func healSelfHealing()
    func passiveManaRegen()
    func takeDamage(dmg: Int) -> Bool
    func atkFocusPunch(target: Enemy) -> Int
    func atkDestruction(target: Enemy) -> Int
//    func atkIllusion(target: Enemy) -> Int
//    func atkCorruption(target: Enemy) -> Int
}

extension CombatSkillsPlayer where Self: MainCharacter {
    func healSelfHealing() {
        if self.currentMana >= 5 {
            self.playAnimation(state: .combat_attack, combatSprite: self.combatSprite)
            let healingValue = self.maxHealth / 4 + (self.attack * 2)
            self.currentMana -= 5
            self.currentHealth += healingValue
            if self.currentHealth > self.maxHealth {
                self.currentHealth = self.maxHealth
            }
        }
    }
    
    func passiveManaRegen() {
        if self.currentMana < self.maxMana { self.currentMana += 1 }
    }
    
    func takeDamage(dmg: Int) -> Bool {
        self.currentHealth -= dmg
        
        if self.currentHealth <= 0 {
            return true
        }
        return false
    }
    
    func death(completion: () -> ()) {
        //self.combatSprite.run(.fadeAlpha(to: 0, duration: 2.5))
        completion()
    }
    
    func atkFocusPunch(target: Enemy) -> Int {
        if self.currentMana < self.maxMana { self.currentMana += 1 }
        
        self.playAnimation(state: .combat_attack, combatSprite: self.combatSprite)
        let damage: Int = (attack * 2) - (target.defense / 2)
        return damage
    }
    
    func atkDestruction(target: Enemy) -> Int {
        if self.currentMana < 6 { return -1 }
        self.currentMana -= 6
        
        self.playAnimation(state: .combat_attack, combatSprite: self.combatSprite)
        let damage: Int = (attack * 5) - (target.defense / 2)
        return damage
    }
}
