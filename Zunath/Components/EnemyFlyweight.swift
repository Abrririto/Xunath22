//
//  EnemyFlyweight.swift
//  Xunath
//
//  Created by Paulo César on 03/11/22.
//

import Foundation
import SpriteKit

class EnemyFlyweight: SKSpriteNode, AnimatedEnemy {
    var atlas: SKTextureAtlas?
    var idleUp: [SKTexture] = []
    var idleDown: [SKTexture] = []
    var idleSide: [SKTexture] = []
    var idleCombat: [SKTexture] = []
    var attackCombat: [SKTexture] = []
    var walkUp: [SKTexture] = []
    var walkDown: [SKTexture] = []
    var walkSide: [SKTexture] = []
    var dmgFocusPunch: [SKTexture] = []
    var dmgDestruction: [SKTexture] = []
    var dmgIllusion: [SKTexture] = []
    var dmgCorruption: [SKTexture] = []
    
    var lastDirection: AnimationDirection?
    var currentDirection: AnimationDirection?
    
    init(type: EnemyTypes) {
        switch type {
        case .commomEnemy:
            self.atlas = SKTextureAtlas(named: "CommonEnemy")
        case .blindMage:
            self.atlas = SKTextureAtlas(named: "CommonEnemy")
        case .knight:
            self.atlas = SKTextureAtlas(named: "CommonEnemy")
        case .cleric:
            self.atlas = SKTextureAtlas(named: "CommonEnemy")
        }
        super.init(texture: nil, color: .red, size: CGSize(width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
