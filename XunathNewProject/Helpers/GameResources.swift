//
//  Resources.swift
//  Macro
//
//  Created by Paulo César on 19/09/22.
//

import Foundation
import SpriteKit

class GameResources: SKNode {
    var commonEnemy = EnemyFlyweight(type: .commomEnemy)
    var enemies: [Enemy] = []
    
    override init() {
        super.init()
        commonEnemy.initializeAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createEnemy(coordA: CGPoint, typeOfEnemy: EnemyTypes) {
        let enemy = Enemy(typeOfEnemy, self.commonEnemy)
        enemy.position = coordA
        enemy.name = "enemy_\(enemies.count)"
//        commonEnemy.passAnimationsByReference(to: enemy)
        enemies.append(enemy)
        self.addChild(enemy)
        print("\(String(describing: enemy.name)) was created")
    }
}
