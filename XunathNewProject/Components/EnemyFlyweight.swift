//
//  EnemyFlyweight.swift
//  Xunath
//
//  Created by Paulo César on 03/11/22.
//

import Foundation
import SpriteKit

class EnemyFlyweight: AnimatedCharacterClass {
    init(type: EnemyTypes) {
        super.init()
        switch type {
        case .commomEnemy:
            atlas = SKTextureAtlas(named: "CommonEnemy")
        case .blindMage:
            atlas = SKTextureAtlas(named: "CommonEnemy")
        case .knight:
            atlas = SKTextureAtlas(named: "CommonEnemy")
        case .cleric:
            atlas = SKTextureAtlas(named: "CommonEnemy")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

