//
//  FirstLevel.swift
//  XunathNewProject
//
//  Created by Arthur Martins Saraiva on 16/11/22.
//

import Cocoa
import SpriteKit

class FirstLevel: SKScene, SKPhysicsContactDelegate {
    var character = MainCharacter()
    var webcam = MainCamera()
    var enemies = [Enemy]()
    var interactionAreas = [InteractionArea]()
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        
        for enemy in enemies {
            self.addChild(enemy)
        }
        
        for interactionArea in interactionAreas {
            self.addChild(interactionArea)
        }
        
        setCamera()
        setCharacter()
    }
    
    func setCharacter() {
        character.setScale(3)
        character.position = CGPoint(x: -17920, y: 8320)
        character.initializeAnimations()
        character.playAnimation(state: .idle, direction: .down)
        self.addChild(character)
        character.levelUp()
    }
    
    func setCamera() {
        self.camera = webcam
        self.addChild(webcam)
        webcam.createInteraction()
        webcam.createTextBox()
        webcam.setScale(3.5)
    }
    
    override func update(_ currentTime: TimeInterval) {
        webcam.run(.move(to: character.position, duration: 0.25))
        character.updatePosition()
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case WalkKeybinds.UP.rawValue, WalkKeybinds.ALTERNATIVEUP.rawValue,
            WalkKeybinds.DOWN.rawValue, WalkKeybinds.ALTERNATIVEDOWN.rawValue,
            WalkKeybinds.LEFT.rawValue, WalkKeybinds.ALTERNATIVELEFT.rawValue,
            WalkKeybinds.RIGHT.rawValue, WalkKeybinds.ALTERNATIVERIGHT.rawValue:
            self.character.stopMoving(event.keyCode)
        default: print("Movimento não registrado.")
        }
        self.character.makeTheCorrectAnimationRun(event: event)
        self.character.isStoppedAnimation()
    }
    
    override func keyDown(with event: NSEvent) {
        character.startMoving(event.keyCode)
        character.makeTheCorrectAnimationRun(event: event)
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
