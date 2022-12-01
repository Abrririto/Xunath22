//
//  FlyweightAnimatedEnemy.swift
//  Xunath
//
//  Created by Paulo César on 04/11/22.
//

import Foundation
import SpriteKit

protocol FlyweightAnimatedEnemy {
    var flyweight: EnemyFlyweight? { get set }
    func playAnimation(state: AnimationSet, direction: AnimationDirection)
    func playAnimation(state: AnimationSet, combatSprite: SKSpriteNode)
}

extension FlyweightAnimatedEnemy where Self: Enemy {
    func playAnimation(state: AnimationSet, direction: AnimationDirection) {
        self.worldSprite.removeAction(forKey: "spriteAnimation")
        guard let flyweight = flyweight else { return }
        switch state {
        case .idle:
            switch direction {
            case .up:
                self.worldSprite.run(.repeatForever(.animate(with: flyweight.idleUp, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .down:
                self.worldSprite.run(.repeatForever(.animate(with: flyweight.idleDown, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .side:
                self.worldSprite.run(.repeatForever(.animate(with: flyweight.idleSide, timePerFrame: 0.1)), withKey: "spriteAnimation")
            }
        case .walk:
            switch direction {
            case .up:
                self.worldSprite.run(.repeatForever(.animate(with: flyweight.walkUp, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .down:
                self.worldSprite.run(.repeatForever(.animate(with: flyweight.walkDown, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .side:
                self.worldSprite.run(.repeatForever(.animate(with: flyweight.walkSide, timePerFrame: 0.1)), withKey: "spriteAnimation")
            }
        default:
            break
        }
    }
    
    func playAnimation(state: AnimationSet, combatSprite: SKSpriteNode) {
        combatSprite.removeAction(forKey: "combatAnimation")
        guard let flyweight = flyweight else { return }
        switch state {
        case .combat_idle:
            combatSprite.run(.repeatForever(.animate(with: flyweight.idleCombat, timePerFrame: 0.1)), withKey: "combatAnimation")
        case .combat_attack:
            combatSprite.run(.animate(with: flyweight.attackCombat, timePerFrame: 0.1), completion: { self.playAnimation(state: .combat_idle, combatSprite: combatSprite) })
        default:
            break
        }
    }
}
