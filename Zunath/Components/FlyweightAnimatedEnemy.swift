//
//  FlyweightAnimatedEnemy.swift
//  Xunath
//
//  Created by Paulo César on 04/11/22.
//

import Foundation
import SpriteKit

protocol FlyweightAnimatedEnemy {
    var flyweight: EnemyFlyweight! { get set }
    func playAnimation(state: AnimationSet, direction: AnimationDirection)
    func playAnimation(state: AnimationSet, combatSprite: SKSpriteNode)
    func playAnimation(skill: PlayerAggressiveSkills, combatEffectSprite: SKSpriteNode, completion: () -> ())
}

extension FlyweightAnimatedEnemy where Self: Enemy {
    func playAnimation(state: AnimationSet, direction: AnimationDirection) {
        self.worldSprite.removeAction(forKey: "spriteAnimation")
        
        switch state {
        case .idle:
//            self.removeAction(forKey: "spriteAnimation_Idle")
            switch direction {
            case .up:
                self.worldSprite.run(.repeatForever(.animate(with: self.flyweight.idleUp, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .down:
                self.worldSprite.run(.repeatForever(.animate(with: self.flyweight.idleDown, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .side:
                self.worldSprite.run(.repeatForever(.animate(with: self.flyweight.idleSide, timePerFrame: 0.1)), withKey: "spriteAnimation")
            }
        case .walk:
            switch direction {
            case .up:
                self.worldSprite.run(.repeatForever(.animate(with: self.flyweight.walkUp, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .down:
                self.worldSprite.run(.repeatForever(.animate(with: self.flyweight.walkDown, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .side:
                self.worldSprite.run(.repeatForever(.animate(with: self.flyweight.walkSide, timePerFrame: 0.1)), withKey: "spriteAnimation")
            }
        default:
            break
        }
    }
    
    func playAnimation(state: AnimationSet, combatSprite: SKSpriteNode) {
        combatSprite.removeAction(forKey: "combatAnimation")
        
        switch state {
        case .combat_idle:
            combatSprite.run(.repeatForever(.animate(with: self.flyweight.idleCombat, timePerFrame: 0.1)), withKey: "combatAnimation")
        case .combat_attack:
            combatSprite.run(.animate(with: self.flyweight.attackCombat, timePerFrame: 0.1), completion: { self.playAnimation(state: .combat_idle, combatSprite: combatSprite) })
        default:
            break
        }
    }
    
    func playAnimation(skill: PlayerAggressiveSkills, combatEffectSprite: SKSpriteNode, completion: () -> ()) {
        combatEffectSprite.removeAction(forKey: "combatEffectAnimation")
        var action: SKAction
        
        self.combatEffectSprite.alpha = 1
        
        switch skill {
        case .focusPunch:
            action = .animate(with: self.flyweight.dmgFocusPunch, timePerFrame: 0.1)
//            print(self.flyweight.dmgFocusPunch)
//            combatEffectSprite.run(.animate(with: self.flyweight.dmgFocusPunch, timePerFrame: 0.1), withKey: "combatEffectAnimation")
//        case .dmgCorruption:
//            combatEffectSprite.run(.animate(with: self.dmgCorruption, timePerFrame: 0.1), withKey: "combatEffectAnimation")
        case .eruption:
            action = .animate(with: self.flyweight.dmgDestruction, timePerFrame: 0.1)
//            combatEffectSprite.run(.animate(with: self.flyweight.dmgDestruction, timePerFrame: 0.1), withKey: "combatEffectAnimation")
//        case .dmgIllusion:
//            combatEffectSprite.run(.animate(with: self.dmgIllusion, timePerFrame: 0.1), withKey: "combatEffectAnimation")
        }
        
        combatEffectSprite.run(action, completion: {
            self.combatEffectSprite.alpha = 0
        })
        
        completion()
    }
}
