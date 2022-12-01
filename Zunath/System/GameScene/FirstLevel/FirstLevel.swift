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
    var webcam = MainCamera()
    var gameSceneDelegate: GameSceneProtocol?
    //    var enemies = [Enemy]()
    //    var interactionAreas = [InteractionArea]()

    var resources: GameResources = GameResources()
    
    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self
        
        
        self.camera = webcam
        self.addChild(webcam.setOnMap(webcam))
        
        character.initializeAnimations()
        self.addChild(character.setOnMap(character))
        setCollision(self.childNode(withName: "ColisionObjects") as! SKTileMapNode, configType: .setCollision)
        setCollision(self.childNode(withName: "SpecialColisionObjects") as! SKTileMapNode, configType: .setCollision)
        setCollision(self.childNode(withName: "InteractableWall") as! SKTileMapNode, configType: .setInteraction)
//        if let designAdjust = self.childNode(withName: "DesignAdjusts") as? SKTileMapNode {
//            setDesignAdjusts(designAdjust)
//        }
        if let node = self.childNode(withName: "SavePortal") as? SKSpriteNode {
            createSavePortal(node)
        }
        
        if let node = self.childNode(withName: "Ladder") as? SKSpriteNode {
            createLadder(node)
        }
//        if let node = self.childNode(withName: "SavePortal2") as? SKSpriteNode {
//            createSavePortal(node)
//        }
        self.addChild(resources)
        initializeEnemies()
    }
    
    func createLadder(_ node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width / 2, height: node.size.height / 2))
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = BitMasks.player.rawValue
        node.physicsBody?.categoryBitMask = BitMasks.ladder.rawValue
    }
    
    func createSavePortal(_ node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: node.size.width / 2, height: node.size.height / 2))
        node.physicsBody?.isDynamic = false
        node.physicsBody?.contactTestBitMask = BitMasks.player.rawValue
        node.physicsBody?.categoryBitMask = BitMasks.savePortal.rawValue
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
        let playerIsBodyA: Bool? = character.checkCharacter(contact: contact)
        guard let playerIsBodyA = playerIsBodyA else { return }
        if playerIsBodyA {
            checkSaveContact(contact: contact)
            checkLadderContact(contact: contact)
            checkEnemyVision(contact: contact)
        } else {
            checkEnemyVision(contact: contact)
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let playerIsBodyA: Bool? = character.checkCharacter(contact: contact)
        guard playerIsBodyA != nil else { return }
        checkSaveContact(contact: contact)
    }
    
    func checkEnemyVision(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == BitMasks.enemyVision.rawValue {
            character.removeFromParent()
            character.clearMovementBuffer()
            gameSceneDelegate?.changeScene(scene: .SecondLevel)
        }
    }
    
    func setDesignAdjusts(_ tileMap: SKTileMapNode) {
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if tileMap.tileDefinition(atColumn: col, row: row) != nil {
                    let node = SKSpriteNode(color: .clear, size: CGSize(width: 200, height: 200))
                    node.position = tileMap.centerOfTile(atColumn: col, row: row)
                    node.position = CGPoint(x: node.position.x + 10, y: node.position.y + 60)
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.contactTestBitMask = BitMasks.player.rawValue
                    node.physicsBody?.categoryBitMask = BitMasks.designWall.rawValue
                    self.addChild(node)
                }
            }
        }
    }
}

extension FirstLevel {
    func setCollision(_ tileMap: SKTileMapNode, configType: MapConfigTypes) {
        let interactionWall = InteractionWall()
        var interactionNumber = 1
        var firstBlockPosition: CGPoint?
        var countBlocks: CGFloat = 0
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                switch configType {
                case .setCollision:
                    if tileMap.tileDefinition(atColumn: col, row: row) != nil {
                        self.addChild(Collision.create(tileMap, col: col, row: row))
                    }
                case .setInteraction:
                    if tileMap.tileDefinition(atColumn: col, row: row) != nil {
                        interactionWall.checkPosition(tileMap, &firstBlockPosition, &countBlocks, col: col, row: row)
                    } else if countBlocks != 0 {
                        guard let node = interactionWall.create(&interactionNumber, &firstBlockPosition, &countBlocks) else { return }
                        self.resources.createInteractionArea(sprite: node, size: node.size, textContent: InteractionTextsLevel1.text0)
                        self.addChild(node)
                    }
                case .setDesignAdjust: break
                    
                }
            }
        }
    }
    
    func checkSaveContact(contact: SKPhysicsContact) {
        if contact.bodyB.categoryBitMask == BitMasks.savePortal.rawValue {
            webcam.interactSaveMessage()
        }
        if contact.bodyB.categoryBitMask == BitMasks.designWall.rawValue {
            character.zPosition = 2
        } else {
            character.zPosition = 4
        }
        if contact.bodyB.categoryBitMask == BitMasks.interactable.rawValue {
            print("Zona de interação")
        }
    }
    
    func checkLadderContact(contact: SKPhysicsContact) {
        if contact.bodyB.categoryBitMask == BitMasks.ladder.rawValue {
            character.removeFromParent()
            character.clearMovementBuffer()
            gameSceneDelegate?.changeScene(scene: .SecondLevel)
        }
    }
    
    func initializeEnemies() {
        resources.createEnemy(coordA: CGPoint(x: -14080, y: 8320), typeOfEnemy: .commomEnemy)
        resources.enemies[0].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[0].moveToX(xPos: -15310, timeWalking: 2)
        resources.enemies[0].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[0].moveToX(xPos: -14080, timeWalking: 2)
        resources.enemies[0].run(.repeatForever(.sequence(resources.enemies[0].toMove)), withKey: "MovementRoutine")
    }
}

enum MapConfigTypes: String {
    case setCollision
    case setDesignAdjust
    case setInteraction
}

enum InteractionTextsLevel1 {
    static var text1 = ["Controls: \n\nUse the arrow keys or WASD to move around. \nPress Z or M to interact.", "Good luck! You'll need it..."]
    static var text0 = ["Be aware: enemies still do their rounds while you read. Careful to not be seen off guard."]
}
