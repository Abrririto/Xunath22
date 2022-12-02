//
//  CombatScene.swift
//  Macro
//
//  Created by Paulo César on 18/10/22.
//

import Foundation
import SpriteKit
import SwiftUI

class CombatScene: SKScene {
    var resources: GameResources = GameResources()
    var enemiesAvailable: [EnemyTypes]
    
    var enemyA: Enemy!
    var enemyB: Enemy?
    var enemyC: Enemy?
    
    var character: MainCharacter = Resources.mainCharacter
    var webcam = MainCamera()
     var gameSceneDelegate: GameSceneProtocol?

    let viewModel: CombatViewModel
    var sceneManagerViewModel: SceneManagerViewModel?
    
    init(enemiesAvailable: [EnemyTypes], viewModel: CombatViewModel) {
        self.enemiesAvailable = enemiesAvailable
        self.viewModel = viewModel
        super.init(size: Size.screenSize)
        self.camera = webcam
        self.addChild(viewModel.auxNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    // Quando essa cena for apresentada pela view, essa função é chamada
    override func didMove(to view: SKView) {
        generateEnemies()
        organizeInScreenSprites()
        showEveryoneHealth()    }
    
    override func keyDown(with event: NSEvent) {
//        switch event.keyCode {
//        case CombatKeybinds.ATTACK.rawValue:
//            viewModel.selectedHUD.toggle()
//            if viewModel.selectedHUD {
//                print("main")
////                viewModel.changeButtonSetTo(.mainSelection)
//            } else {
//                print("attack")
////                viewModel.changeButtonSetTo(.attackSelection)
//            }
//
//        default:
//            break
//        }
        
//        if event.keyCode == CombatKeybinds.FLEE.rawValue {
//            sceneManagerViewModel.changeScene(scene: .GameScene)
//        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    

    func showEveryoneHealth() {
        print("Your health (Lv. \(character.level)): \(character.currentHealth) / \(character.maxHealth)")
        if let enemyA = enemyA {
            print("Enemy A's health (Lv. \(enemyA.level)): \(enemyA.currentHealth) / \(enemyA.maxHealth)")
        }
        if let enemyB = enemyB {
            print("Enemy B's health (Lv. \(enemyB.level)): \(enemyB.currentHealth) / \(enemyB.maxHealth)")
        }
        if let enemyC = enemyC {
            print("Enemy C's health (Lv. \(enemyC.level)): \(enemyC.currentHealth) / \(enemyC.maxHealth)")
        }
    }

    func organizeInScreenSprites() {
    
        character.combatSprite.position = CGPoint(x: -250, y: 75)
        character.playAnimation(state: .combat_idle, combatSprite: character.combatSprite)
        if character.combatSprite.parent == nil { addChild(character.combatSprite) }
        
//        enemyA.initializeAnimations()
        enemyA.combatSprite.texture = resources.commonEnemy.idleCombat[0]
        enemyA.combatSprite.position.x = -character.combatSprite.position.x
        enemyA.combatSprite.position.y = character.combatSprite.position.y
        if enemyA.combatSprite.parent == nil { addChild(enemyA.combatSprite); enemyA.combatSprite.addChild(enemyA.combatEffectSprite) }
        if let enemyB = enemyB {
//            enemyB.initializeAnimations()
//            enemyB.combatSprite.color = NSColor(red: .random(in: 0..<1), green: .random(in: 0..<1), blue: .random(in: 0..<1), alpha: 1)
//            enemyB.combatSprite.colorBlendFactor = 0.75
            enemyB.combatSprite.texture = resources.commonEnemy.idleCombat[0]
            enemyB.combatSprite.position.x = enemyA.combatSprite.position.x + 75
            enemyB.combatSprite.zPosition = 1
            enemyB.combatSprite.position.y = enemyA.combatSprite.position.y - 103
            if enemyB.combatSprite.parent == nil { addChild(enemyB.combatSprite); enemyB.combatSprite.addChild(enemyB.combatEffectSprite) }
        }
        if let enemyC = enemyC {
//            enemyC.initializeAnimations()
//            enemyC.combatSprite.color = NSColor(red: .random(in: 0..<1), green: .random(in: 0..<1), blue: .random(in: 0..<1), alpha: 1)
//            enemyC.combatSprite.colorBlendFactor = 0.75
            enemyC.combatSprite.texture = resources.commonEnemy.idleCombat[0]
            enemyC.combatSprite.position.x = enemyA.combatSprite.position.x + 50
            enemyC.combatSprite.zPosition = -1
            enemyC.combatSprite.position.y = enemyA.combatSprite.position.y + 103
            if enemyC.combatSprite.parent == nil { addChild(enemyC.combatSprite); enemyC.combatSprite.addChild(enemyC.combatEffectSprite) }
        }
    }
    
    func generateEnemies() {
        deinitializeEnemies()
        let random = Int.random(in: 0..<10)
        
        // https://pbs.twimg.com/ext_tw_video_thumb/1289337674659172353/pu/img/yxGQLKMSIN_Rxypp.jpg
        
        if random >= 0 && random < 10 {
            enemyA = Enemy(enemiesAvailable.randomElement() ?? .commomEnemy, self.resources.commonEnemy)
            enemyA.setCombatLevel(Int.random(in: 1..<4))
        }
        
        if random >= 0 && random < 5 {
            enemyB = Enemy(enemiesAvailable.randomElement() ?? .commomEnemy, self.resources.commonEnemy)
            enemyB!.setCombatLevel(Int.random(in: 1..<4))
        }
        
        if random >= 0 && random < 2 {
            enemyC = Enemy(enemiesAvailable.randomElement() ?? .commomEnemy, self.resources.commonEnemy)
            enemyC!.setCombatLevel(Int.random(in: 1..<4))
        }
    }
    
    func deinitializeEnemies() {
        if let enemyA = enemyA { enemyA.combatSprite.removeFromParent() }
        if let enemyB = enemyB { enemyB.combatSprite.removeFromParent() }
        if let enemyC = enemyC { enemyC.combatSprite.removeFromParent() }
        
        enemyA = nil
        enemyB = nil
        enemyC = nil
    }
    
    func changeButtonsVisibilityOnScreen(buttons: [CombatButton], visible: Bool) {
        if visible {
            for button in buttons {
                button.isHidden = false
            }
        } else {
            for button in buttons {
                button.isHidden = true
            }
        }
    }
    
    private func organizeButtonsOnScreen(buttons: [CombatButton]) {
        let offset = (self.size.width / CGFloat(buttons.count))
        var pos = -offset
        
        for button in buttons {
            button.position.x = pos
            pos += offset
            button.isHidden = true
            webcam.addChild(button)
        }
    }
}
