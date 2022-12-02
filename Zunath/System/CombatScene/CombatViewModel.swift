//
//  CombatViewModel.swift
//  Xunath
//
//  Created by Paulo César on 24/10/22.
//

import Foundation
import SpriteKit
import SwiftUI

class CombatViewModel: ObservableObject {
    @Published var selectedHUD: Bool = false
    
    var sceneManagerViewModel: SceneManagerViewModel?
    
    var auxNode = SKNode()
    var buttonSFX = SKAction.playSoundFileNamed("button", waitForCompletion: false)
    
    var defeatedEnemies: (Bool, Bool, Bool) = (false, false, false)
    
    func changeButtonSetTo(_ set: CombatButtonState) {
        switch set {
        case .mainSelection:
            self.selectedHUD = false
        case .attackSelection:
            self.selectedHUD = true
        }
    }
    
    func playButtonSFX() {
        if auxNode.parent != nil {
            auxNode.run(buttonSFX)
        }
    }
    
    func playerHealedThemselves(target: MainCharacter) {
//        target.playAnimation(state: .combat_attack, combatSprite: target.combatSprite)
        target.healSelfHealing()
    }
    
    func entityAttackedEntity(sender: MainCharacter, target: Enemy, skill: PlayerAggressiveSkills) {
        let charDamage: Int
        switch skill {
        case .focusPunch:
            charDamage = sender.atkFocusPunch(target: target)
        case .eruption:
            charDamage = sender.atkDestruction(target: target)
        }
        
        let targetLost = target.takeDamage(dmg: charDamage)
        
        if targetLost {
            target.hasBeenDefeated = true
            target.combatSprite.run(.sequence([.fadeAlpha(to: 0, duration: 1),
                                               .removeFromParent()]))
        }
    }
    
    func entityAttackedEntity(sender: Enemy, target: MainCharacter, sceneManager: SceneManagerViewModel) {
        let enemyDamage = sender.commonAttack(target: target)
        let playerLost = target.takeDamage(dmg: enemyDamage)
        
        
        if playerLost {
            sceneManagerViewModel?.changeSceneFromOutside(scene: Level.scene)
            sceneManagerViewModel?.loadGame()
            target.currentHealth = target.maxHealth
            target.currentMana = target.maxMana
        }
    }
    
    func whichEnemyWillBeAttacked(enemyA: Enemy?, enemyB: Enemy?, enemyC: Enemy?) -> Enemy! {
        if let enemyA = enemyA, !enemyA.hasBeenDefeated { return enemyA }
        if let enemyB = enemyB, !enemyB.hasBeenDefeated { return enemyB }
        if let enemyC = enemyC, !enemyC.hasBeenDefeated { return enemyC }
        
        return nil
    }
    
    func executeTurn(player: MainCharacter, enemyA: Enemy?, enemyB: Enemy?, enemyC: Enemy?, attackUsed: PlayerAllSkills, sceneManager: SceneManagerViewModel, completion: @escaping (Int) -> ()) {
        
        let skillUsed: PlayerAggressiveSkills!
        
        switch attackUsed {
        case .focusPunch:
            skillUsed = .focusPunch
        case .eruption:
            skillUsed = .eruption
        case .healing:
            skillUsed = nil
            player.playAnimation(state: .combat_attack, combatSprite: player.combatSprite, completion: {
                self.playerHealedThemselves(target: player)
            })
        }
        
        if let skillUsed = skillUsed {
            if let enemyTarget = self.whichEnemyWillBeAttacked(enemyA: enemyA, enemyB: enemyB, enemyC: enemyC) {
                player.playAnimation(state: .combat_attack, combatSprite: player.combatSprite)
                                
                enemyTarget.playAnimation(skill: skillUsed, combatEffectSprite: enemyTarget.combatEffectSprite, completion: {
                    self.entityAttackedEntity(sender: player, target: enemyTarget, skill: skillUsed)
                })
            }
        }
        
        // END OF PLAYER'S TURN
        
        if let enemyA = enemyA, !enemyA.hasBeenDefeated { self.entityAttackedEntity(sender: enemyA, target: player, sceneManager: sceneManager)} else {
            defeatedEnemies.0 = true
        }
        if let enemyB = enemyB, !enemyB.hasBeenDefeated { self.entityAttackedEntity(sender: enemyB, target: player, sceneManager: sceneManager)} else {
            defeatedEnemies.1 = true
        }
        if let enemyC = enemyC, !enemyC.hasBeenDefeated { self.entityAttackedEntity(sender: enemyC, target: player, sceneManager: sceneManager)} else {
            defeatedEnemies.2 = true
        }
        
        player.passiveManaRegen()

        if defeatedEnemies == (true, true, true) {
            EnemyThatSeenCharEnum.lastSeenEnemy.removeFromParent()
            defeatedEnemies = (false, false, false)
            sceneManagerViewModel?.changeSceneFromOutside(scene: Level.scene)
            return
        }
        
        completion(player.currentMana)
    }
    
//    func createButtons() {
//        combatHUD["mainState"] = HStack {
//            CombatButtonSUI(mainText: "Attack", shortcutText: "A", isEnabled: true)
//            CombatButtonSUI(mainText: "Heal", shortcutText: "S", isEnabled: true)
//            CombatButtonSUI(mainText: "Flee", shortcutText: "D", isEnabled: true)
//        }
//        
//        combatHUD["attackState"] = HStack {
//            CombatButtonSUI(mainText: "Focus Punch", shortcutText: "A", isEnabled: true)
//            CombatButtonSUI(mainText: "Duplicate", shortcutText: "S", isEnabled: true)
//            CombatButtonSUI(mainText: "Eruption", shortcutText: "D", isEnabled: false)
//            CombatButtonSUI(mainText: "Weaken", shortcutText: "F", isEnabled: false)
//            CombatButtonSUI(mainText: "Back", shortcutText: "G", isEnabled: true)
//        }
//    }
}
