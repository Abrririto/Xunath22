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
        /// Espero que de conflito grr
        self.camera = webcam
        self.addChild(webcam.setOnMap(webcam))
        character.initializeAnimations()
        self.addChild(character.setOnMap(character))
        setCollision(self.childNode(withName: "ColisionObjects") as! SKTileMapNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        webcam.run(.move(to: character.position, duration: 0.25))
        character.updatePosition()
    }
    
    override func keyDown(with event: NSEvent) {
        character.startMoving(event.keyCode)
        character.makeTheCorrectAnimationRun(event: event)
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
}

extension FirstLevel {
    func setCollision(_ tileMap: SKTileMapNode) {
        let collision = Collision()
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if tileMap.tileDefinition(atColumn: col, row: row) != nil {
                    self.addChild(collision.create(tileMap, col: col, row: row))
                }
            }
        }
    }
}
