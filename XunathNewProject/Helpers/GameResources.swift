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
//    var coins: [Coin] = []
    var interactionAreas: [InteractionArea] = []
    
    override init() {
        super.init()
        
        commonEnemy.initializeAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    func createInteractionArea(sprite: SKSpriteNode, size: CGSize, textContent: [String]) {
        let area = InteractionArea(node: sprite, size: size, textContent: textContent)
        area.fillColor = .orange
        area.name = "interact_\(interactionAreas.count)"
        interactionAreas.append(area)
        self.addChild(area)
        print("\(String(describing: area.name)) was created, linked to \(String(describing: sprite.name))")
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
