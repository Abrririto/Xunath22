//
//  FirstLevel.swift
//  XunathNewProject
//
//  Created by Arthur Martins Saraiva on 16/11/22.
//

import Cocoa
import SpriteKit

class FirstLevel: SKScene, SKPhysicsContactDelegate {
    var character: MainCharacter = Resources.mainCharacter
    var webcam = Resources.camera
    
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
        initializeEnemies()
        createCollision(self.childNode(withName: "ColisionObjects") as! SKTileMapNode)
        
//        scanThroughInteraction(self.childNode(withName: "InteractableWall") as! SKTileMapNode)
        
        if let node = self.childNode(withName: "SavePortal1") as? SKSpriteNode {
            createSavePortal(node: node)
        }
        if let node = self.childNode(withName: "SavePortal2") as? SKSpriteNode {
            createSavePortal(node: node)
        }
    }
    
    func createSavePortal(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width / 2, height: node.size.height / 2))
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = BitMasks.player.rawValue
        node.physicsBody?.categoryBitMask = BitMasks.savePortal.rawValue
    }
    
    func setCamera() {
        self.camera = webcam
        self.addChild(webcam.setOnMap(webcam))
        character.initializeAnimations()
        self.addChild(character.setOnMap(character))
        createCollision(self.childNode(withName: "ColisionObjects") as! SKTileMapNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        webcam.run(.move(to: character.position, duration: 0.25))
        character.updatePosition()
    }
    
    override func keyDown(with event: NSEvent) {
        character.startMoving(event.keyCode)
        character.makeTheCorrectAnimationRun(event: event)
        if webcam.isSaveMessageShowing {
            
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
            case InteractKeybinds.INTERACT.rawValue,
                InteractKeybinds.INTERACT.rawValue:
                if webcam.isSaveMessageShowing {
                    SaveManager.shared.saveGame()
                    print("Saving Game")
                    return
                }
                
//                if !webcam.textBoxHasContent {
//                    guard let interaction = resources.interactionAreas.first(where: {$0.isInsideArea == true}) else { return }
//                    self.gameIsActive = interaction.interact()
//                } else {
//                    self.gameIsActive = webcam.displayTextBox()
//                }
                
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
                    self.addChild(Collision.create(tileMap, col: col, row: row))
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
    
    func initializeEnemies() {
        resources.createEnemy(coordA: CGPoint(x: -30, y: -2680), typeOfEnemy: .commomEnemy)
        resources.enemies[0].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[0].moveToX(xPos: 1280, timeWalking: 2)
//        resources.enemies[0].moveToPoint(therePoint: CGPoint(x: 1280, y: -2680), timeWalking: 2)
        resources.enemies[0].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[0].moveToX(xPos: -30, timeWalking: 2)
//        resources.enemies[0].moveToPoint(therePoint: CGPoint(x: -30, y: -2680), timeWalking: 2)
        resources.enemies[0].run(.repeatForever(.sequence(resources.enemies[0].toMove)), withKey: "MovementRoutine")
                
        resources.createEnemy(coordA: CGPoint(x: 2240, y: -860), typeOfEnemy: .commomEnemy)
        resources.enemies[1].lookToAngle(angleToSee: -225, timeTurning: 1)
        resources.enemies[1].moveToY(yPos: -2350, timeWalking: 2.7)
//        resources.enemies[1].moveToPoint(therePoint: CGPoint(x: 2240, y: -2350), timeWalking: 2.7)
        resources.enemies[1].lookToAngle(angleToSee: -45, timeTurning: 1)
//        resources.enemies[1].startVision(timeTurning: 0.7)
        resources.enemies[1].moveToY(yPos: -860, timeWalking: 2.7)
//        resources.enemies[1].moveToPoint(therePoint: CGPoint(x: 2240, y: -860), timeWalking: 2.7)
        resources.enemies[1].run(.repeatForever(.sequence(resources.enemies[1].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 5720, y: -1940 /*-1000*/), typeOfEnemy: .commomEnemy)
        resources.enemies[2].lookToAngle(angleToSee: 90, timeTurning: 0.7) // 90
        resources.enemies[2].overrideIdleAnimation(direction: .down)
        resources.enemies[2].run(.sequence(resources.enemies[2].toMove), withKey: "MovementRoutine")
//        resources.enemies[2].playAnimation(state: .idle, direction: .down)
//
        resources.createEnemy(coordA: CGPoint(x: 3050, y: -5800), typeOfEnemy: .commomEnemy)
        resources.enemies[3].lookToAngle(angleToSee: -134, timeTurning: 0.7)
        resources.enemies[3].moveToX(xPos: 6400, timeWalking: 5)
//        resources.enemies[3].moveToPoint(therePoint: CGPoint(x: 6400, y: -5800), timeWalking: 5)
        resources.enemies[3].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[3].moveToX(xPos: 3050, timeWalking: 5)
//        resources.enemies[3].moveToPoint(therePoint: CGPoint(x: 3050, y: -5800), timeWalking: 5)
        resources.enemies[3].run(.repeatForever(.sequence(resources.enemies[3].toMove)), withKey: "MovementRoutine")
//
        resources.createEnemy(coordA: CGPoint(x: 3050, y: -7500), typeOfEnemy: .commomEnemy)
        resources.enemies[4].lookToAngle(angleToSee: -134, timeTurning: 0.7)
        resources.enemies[4].moveToX(xPos: 6400, timeWalking: 5)
//        resources.enemies[4].moveToPoint(therePoint: CGPoint(x: 6400, y: -7500), timeWalking: 5)

        resources.enemies[4].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[4].moveToX(xPos: 3050, timeWalking: 5)
//        resources.enemies[4].moveToPoint(therePoint: CGPoint(x: 3050, y: -7500), timeWalking: 5)
        resources.enemies[4].run(.repeatForever(.sequence(resources.enemies[4].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -1120, y: -4240), typeOfEnemy: .commomEnemy)
        resources.enemies[5].lookToAngle(angleToSee: 180, timeTurning: 0.7)
        resources.enemies[5].run(.sequence(resources.enemies[5].toMove), withKey: "MovementRoutine")
        resources.createEnemy(coordA: CGPoint(x: 320, y: -5000), typeOfEnemy: .commomEnemy)
        resources.enemies[6].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[6].moveToY(yPos: -7480, timeWalking: 4)
//        resources.enemies[6].moveToPoint(therePoint: CGPoint(x: 320, y: -7480), timeWalking: 4)
        resources.enemies[1].lookToAngle(angleToSee: -45, timeTurning: 0.7)
//        resources.enemies[6].startVision(timeTurning: 0.7)
        resources.enemies[6].moveToY(yPos: -5000, timeWalking: 4)
//        resources.enemies[6].moveToPoint(therePoint: CGPoint(x: 320, y: -5000), timeWalking: 4)
        resources.enemies[6].run(.repeatForever(.sequence(resources.enemies[6].toMove)), withKey: "MovementRoutine")

        resources.createEnemy(coordA: CGPoint(x: 7080, y: -5220), typeOfEnemy: .commomEnemy)
        resources.enemies[7].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[7].run(.sequence(resources.enemies[7].toMove), withKey: "MovementRoutine")
//
        resources.createEnemy(coordA: CGPoint(x: 5380, y: -9040), typeOfEnemy: .commomEnemy)
        resources.enemies[8].lookToAngle(angleToSee: 135, timeTurning: 1.5)
        resources.enemies[8].run(.sequence(resources.enemies[8].toMove), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 10440, y: -320), typeOfEnemy: .commomEnemy)
        resources.enemies[9].lookToAngle(angleToSee: -45, timeTurning: 1.5)
        resources.enemies[9].run(.sequence(resources.enemies[9].toMove), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 8480, y: -2240), typeOfEnemy: .commomEnemy)
        resources.enemies[10].lookToAngle(angleToSee: -135, timeTurning: 1.5)
        resources.enemies[10].run(.sequence(resources.enemies[10].toMove), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 9680, y: -2240), typeOfEnemy: .commomEnemy)
        resources.enemies[11].lookToAngle(angleToSee: -315, timeTurning: 1.5)
        resources.enemies[11].run(.sequence(resources.enemies[11].toMove), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 9040, y: -2880), typeOfEnemy: .commomEnemy)
        resources.enemies[12].lookToAngle(angleToSee: -45, timeTurning: 1.5)
        resources.enemies[12].run(.sequence(resources.enemies[12].toMove), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 8880, y: -7680), typeOfEnemy: .commomEnemy)
        resources.enemies[13].lookToAngle(angleToSee: -225, timeTurning: 1)
//        resources.enemies[13].moveToPoint(therePoint: CGPoint(x: 8880, y: -9280), timeWalking: 2.7)
        resources.enemies[13].startVision(timeTurning: 0.7)
//        resources.enemies[13].moveToPoint(therePoint: CGPoint(x: 8880, y: -7680), timeWalking: 2.7)
        resources.enemies[13].run(.repeatForever(.sequence(resources.enemies[13].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 10560, y: -9280), typeOfEnemy: .commomEnemy)
        resources.enemies[14].lookToAngle(angleToSee: -45, timeTurning: 1)
//        resources.enemies[14].moveToPoint(therePoint: CGPoint(x: 10560, y: -7680), timeWalking: 2.7)
        resources.enemies[14].lookToAngle(angleToSee: 135, timeTurning: 1)
//        resources.enemies[14].moveToPoint(therePoint: CGPoint(x: 10560, y: -9280), timeWalking: 2.7)
        resources.enemies[14].run(.repeatForever(.sequence(resources.enemies[14].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 14880, y: -4420), typeOfEnemy: .commomEnemy)
        resources.enemies[15].lookToAngle(angleToSee: -45, timeTurning: 1.5)
        resources.enemies[15].run(.sequence(resources.enemies[15].toMove), withKey: "MovementRoutine")
    }
}


enum InteractionTextsLevel1 {
    static var text1 = ["Controls: \n\nUse the arrow keys or WASD to move around. \nPress Z or M to interact.", "Good luck! You'll need it..."]
    static var text0 = ["Be aware: enemies still do their rounds while you read. Careful to not be seen off guard."]
}
