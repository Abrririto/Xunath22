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
    //    var enemies = [Enemy]()
    //    var interactionAreas = [InteractionArea]()
    var resources: GameResources = GameResources()
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        //        for enemy in enemies {
        //            self.addChild(enemy)
        //        }
        
        //        for interactionArea in interactionAreas {
        //            self.addChild(interactionArea)
        //        }
        
        setCamera()
        setCharacter()
        createCollision(self.childNode(withName: "ColisionObjects") as! SKTileMapNode)
//        scanThroughInteraction(self.childNode(withName: "InteractableWall") as! SKTileMapNode)
        
        if let node = self.childNode(withName: "SavePortal") as? SKSpriteNode {
            createSavePortal(node: node)
        }
    }
    
    func createSavePortal(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width / 2, height: node.size.height / 2))
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = BitMasks.player.rawValue
        node.physicsBody?.categoryBitMask = BitMasks.savePortal.rawValue
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
    
    override func keyDown(with event: NSEvent) {
        character.startMoving(event.keyCode)
        character.makeTheCorrectAnimationRun(event: event)
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let playerIsBodyA: Bool? = checkPlayer(contact: contact)
        guard let playerIsBodyA = playerIsBodyA else { return }
        if playerIsBodyA {
            checkSaveContact(contact: contact)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let playerIsBodyA: Bool? = checkPlayer(contact: contact)
        guard let playerIsBodyA = playerIsBodyA else { return }
        
        if playerIsBodyA {
            checkSaveContact(contact: contact)
        } else {
            checkSaveContact(contact: contact)
        }
    }
    
    func checkSaveContact(contact: SKPhysicsContact) {
        if contact.bodyB.categoryBitMask == BitMasks.savePortal.rawValue {
            webcam.interactSaveMessage()
        }
    }
    

    func checkPlayer(contact: SKPhysicsContact) -> Bool? {
        if contact.bodyA.categoryBitMask == BitMasks.player.rawValue {
            return true
        } else if contact.bodyB.categoryBitMask == BitMasks.player.rawValue {
           return false
        }
        
        return nil
    }
    
//    func didEnd(_ contact: SKPhysicsContact) {
//        var playerIsBodyA: Bool
//
//        if contact.bodyA.categoryBitMask == BitMasks.player.rawValue {
//            playerIsBodyA = true
//        } else if contact.bodyB.categoryBitMask == BitMasks.player.rawValue {
//            playerIsBodyA = false
//        } else {
//            return
//        }
//
//        if playerIsBodyA {
//            switch contact.bodyB.categoryBitMask {
//                case BitMasks.interactable.rawValue:
//                    guard let bodyB = contact.bodyB.node as? InteractionArea else { return }
//                    bodyB.isInsideArea = false
//                    webcam.toggleInteractionHUDNotification(contact: bodyB.isInsideArea)
//                default:
//                    break
//            }
//        } else {
//            switch contact.bodyA.categoryBitMask {
//                case BitMasks.interactable.rawValue:
//                    guard let bodyA = contact.bodyA.node as? InteractionArea else { return }
//                    bodyA.isInsideArea = false
//                    webcam.toggleInteractionHUDNotification(contact: bodyA.isInsideArea)
//                default:
//                    break
//            }
//        }
//
//    }
    
    func createCollision(_ tileMap: SKTileMapNode) {
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if tileMap.tileDefinition(atColumn: col, row: row) != nil {
                    self.addChild(collision.create(tileMap, col: col, row: row))
                }
            }
        }
    }
    
    
    func createSKNodeInt(size: CGSize, position: CGPoint, intNumber: Int) -> SKSpriteNode {
        let tileNode = SKSpriteNode(color: .clear, size: size)
        tileNode.position = position
        tileNode.name = "Interactable\(intNumber)"
        return tileNode
    }
    
    
    func scanThroughInteraction(_ tileMap: SKTileMapNode) {
        var interactionNumber = 1
        var firstBlockPosition: CGPoint?
        var countBlocks: CGFloat = 0
        for row in 0..<tileMap.numberOfRows {
            for col in 0..<tileMap.numberOfColumns {
                if tileMap.tileDefinition(atColumn: col, row: row) != nil {
                    countBlocks += 1
                    if firstBlockPosition == nil {
                        firstBlockPosition = tileMap.centerOfTile(atColumn: col, row: row)
                    }
                } else if countBlocks != 0 {
                    guard let blockPosition = firstBlockPosition else { return }
                    let size = CGSize(width: countBlocks * 200, height: 200)
                    let middleXPos = (countBlocks * 200)/2
                    let xPos = (blockPosition.x - 100) + middleXPos
                    let yPos = blockPosition.y - 100
                    let node = self.createSKNodeInt(size: size, position: CGPoint(x: xPos, y: yPos), intNumber: interactionNumber)
                    self.resources.createInteractionArea(sprite: node, size: node.size, textContent: InteractionTextsLevel1.text1)
                    interactionNumber += 1
                    countBlocks = 0
                    firstBlockPosition = nil
                }
            }
        }
    }
}


enum InteractionTextsLevel1 {
    static var text1 = ["Controls: \n\nUse the arrow keys or WASD to move around. \nPress Z or M to interact.", "Good luck! You'll need it..."]
    static var text0 = ["Be aware: enemies still do their rounds while you read. Careful to not be seen off guard."]
}
