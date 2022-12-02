//
//  AnimatedEnemy.swift
//  Xunath
//
//  Created by Paulo César on 21/11/22.
//

import Foundation
import SpriteKit

protocol AnimatedEnemy: AnimatedCharacter {
    func getAnimation(atlas: SKTextureAtlas, skill: DamageAnimationSet) -> [SKTexture]
    override mutating func initializeAnimations()
}

extension AnimatedEnemy where Self: EnemyFlyweight {
    func getAnimation(atlas: SKTextureAtlas, skill: DamageAnimationSet) -> [SKTexture] {
        var frames: [SKTexture] = []
        var names = atlas.textureNames.filter({ $0.contains(skill.rawValue) })
        names.sort(by: { $0.localizedStandardCompare($1) == .orderedAscending })
        
        print(names)
        
        for frame in names {
            frames.append(SKTexture(imageNamed: frame))
        }
        
        return frames
    }
    
    mutating func initializeEnemyAnimations() {
        self.initializeAnimations()
        let newAtlas = SKTextureAtlas(named: "DamageEffects")
        
        
        self.dmgFocusPunch.append(contentsOf: self.getAnimation(atlas: newAtlas, skill: .focusPunch))
        self.dmgIllusion.append(contentsOf: self.getAnimation(atlas: newAtlas, skill: .illusion))
        self.dmgCorruption.append(contentsOf: self.getAnimation(atlas: newAtlas, skill: .corruption))
        self.dmgDestruction.append(contentsOf: self.getAnimation(atlas: newAtlas, skill: .destruction))
        
        print("enemy suffering animations loaded")
    }
}
