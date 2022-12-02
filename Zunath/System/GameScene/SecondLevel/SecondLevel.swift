//
//  FirstLevel.swift
//  XunathNewProject
//
//  Created by Arthur Martins Saraiva on 16/11/22.
//

import Cocoa
import SpriteKit

class SecondLevel: SKScene, SKPhysicsContactDelegate {
    var character: MainCharacter = Resources.mainCharacter
    var webcam = MainCamera()
    
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
//        setCollision(self.childNode(withName: "SpecialColisionObjects") as! SKTileMapNode, configType: .setCollision)
//        setCollision(self.childNode(withName: "InteractableWall") as! SKTileMapNode, configType: .setInteraction)
//        if let designAdjust = self.childNode(withName: "DesignAdjusts") as? SKTileMapNode {
//            setDesignAdjusts(designAdjust)
//        }
        if let node = self.childNode(withName: "SavePortal") as? SKSpriteNode {
            createSavePortal(node)
        }
//        if let node = self.childNode(withName: "SavePortal2") as? SKSpriteNode {
//            createSavePortal(node)
//        }
        self.addChild(resources)
        createEnemy()
    }
    
    override func didMove(to view: SKView) {
        let changeScene = SKSpriteNode(color: .black, size: self.size)
        changeScene.zPosition = 1000
        changeScene.alpha = 0
        self.webcam.addChild(changeScene)
        
        self.character.run(.run {
//            self.gameIsActive = false
            changeScene.run(.fadeAlpha(to: 1, duration: 0.01), completion: {
                self.character.run(.move(to: CGPoint(x: 3000, y: -17360), duration: 0.01))
                changeScene.run(.fadeAlpha(to: 0, duration: 1), completion: {
//                    self.gameIsActive = true
                })
            })
        })
       
        AudioPlayerImpl.shared.play(music: Audio.MusicFiles.exploracao)
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
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let playerIsBodyA: Bool? = character.checkCharacter(contact: contact)
        guard playerIsBodyA != nil else { return }
        checkSaveContact(contact: contact)
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

extension SecondLevel {
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
//                        self.resources.createInteractionArea(sprite: node, size: node.size, textContent: InteractionTextsLevel1.text0)
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
    
    func createEnemy() {
        resources.createEnemy(coordA: CGPoint(x: -8640, y: -17280), typeOfEnemy: .commomEnemy)
        resources.enemies[0].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[0].moveToX(xPos: -4480, timeWalking: 5)
        resources.enemies[0].lookToAngle(angleToSee: -45, timeTurning: 0.7)
        resources.enemies[0].moveToY(yPos: -16000, timeWalking: 2)
        resources.enemies[0].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[0].moveToX(xPos: -7360, timeWalking: 3)
        resources.enemies[0].lookToAngle(angleToSee: -45, timeTurning: 0.7)
        resources.enemies[0].moveToY(yPos: -3360, timeWalking: 12)
        resources.enemies[0].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[0].moveToX(xPos: -8640, timeWalking: 3)
        resources.enemies[0].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[0].moveToY(yPos: -17280, timeWalking: 12)
        resources.enemies[0].run(.repeatForever(.sequence(resources.enemies[0].toMove)), withKey: "MovementRoutine")

        resources.createEnemy(coordA: CGPoint(x: 3360, y: -14400), typeOfEnemy: .commomEnemy)
        resources.enemies[1].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[1].moveToX(xPos: 1920, timeWalking: 3)
        resources.enemies[1].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[1].moveToY(yPos: -16640, timeWalking: 4)
        resources.enemies[1].lookToAngle(angleToSee: -45, timeTurning: 0.7)
        resources.enemies[1].moveToY(yPos: -14400, timeWalking: 4)
        resources.enemies[1].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[1].moveToX(xPos: 3360, timeWalking: 3)
        resources.enemies[1].run(.repeatForever(.sequence(resources.enemies[1].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 2000, y: -11760), typeOfEnemy: .commomEnemy)
        resources.enemies[2].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[2].moveToY(yPos: -13600, timeWalking: 3)
        resources.enemies[2].lookToAngle(angleToSee: -45, timeTurning: 0.7)
        resources.enemies[2].moveToY(yPos: -11760, timeWalking: 3)
        resources.enemies[2].run(.repeatForever(.sequence(resources.enemies[2].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 4800, y: -16320), typeOfEnemy: .commomEnemy)
        resources.enemies[3].lookToAngle(angleToSee: -45, timeTurning: 0.7)
        resources.enemies[3].moveToY(yPos: -11900, timeWalking: 6)
        resources.enemies[3].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[3].moveToY(yPos: -16320, timeWalking: 6)
        resources.enemies[3].run(.repeatForever(.sequence(resources.enemies[3].toMove)), withKey: "MovementRoutine")
     
        
        resources.createEnemy(coordA: CGPoint(x: 7680, y: -6240), typeOfEnemy: .commomEnemy)
        resources.enemies[4].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[4].moveToX(xPos: 5120, timeWalking: 3)
        resources.enemies[4].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[4].moveToX(xPos: 7680, timeWalking: 3)
        resources.enemies[4].run(.repeatForever(.sequence(resources.enemies[4].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 2880, y: -6240), typeOfEnemy: .commomEnemy)
        resources.enemies[5].lookToAngle(angleToSee: -135, timeTurning: 0)
        resources.enemies[5].run(.repeatForever(.sequence(resources.enemies[5].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 5280, y: -10640), typeOfEnemy: .commomEnemy)
        resources.enemies[6].lookToAngle(angleToSee: -45, timeTurning: 0)
        resources.enemies[6].run(.repeatForever(.sequence(resources.enemies[6].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 1500, y: -9760), typeOfEnemy: .commomEnemy)
        resources.enemies[7].lookToAngle(angleToSee: -135, timeTurning: 0)
        resources.enemies[7].run(.repeatForever(.sequence(resources.enemies[7].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -6240, y: -7680), typeOfEnemy: .commomEnemy)
        resources.enemies[8].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[8].moveToX(xPos: -3360, timeWalking: 3)
        resources.enemies[8].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[8].moveToX(xPos: -6240, timeWalking: 3)
        resources.enemies[8].run(.repeatForever(.sequence(resources.enemies[8].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -4100, y: -4880), typeOfEnemy: .commomEnemy)
        resources.enemies[9].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[9].moveToX(xPos: -6240, timeWalking: 3)
        resources.enemies[9].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[9].moveToX(xPos: -4100, timeWalking: 3)
        resources.enemies[9].run(.repeatForever(.sequence(resources.enemies[9].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 1760, y: 4800), typeOfEnemy: .commomEnemy)
        resources.enemies[10].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[10].moveToY(yPos: -2000, timeWalking: 8)
        resources.enemies[10].lookToAngle(angleToSee: -45, timeTurning: 0.7)
        resources.enemies[10].moveToY(yPos: 4800, timeWalking: 8)
        resources.enemies[10].run(.repeatForever(.sequence(resources.enemies[10].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 860, y: 5760), typeOfEnemy: .commomEnemy)
        resources.enemies[11].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[11].moveToY(yPos: 5280, timeWalking: 4)
        resources.enemies[11].lookToAngle(angleToSee: -45, timeTurning: 0.7)
        resources.enemies[11].moveToY(yPos: 5760, timeWalking: 4)
        resources.enemies[11].run(.repeatForever(.sequence(resources.enemies[11].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -1280, y: 3800), typeOfEnemy: .commomEnemy)
        resources.enemies[12].lookToAngle(angleToSee: -225, timeTurning: 0)
        resources.enemies[12].run(.repeatForever(.sequence(resources.enemies[12].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 160, y: 3800), typeOfEnemy: .commomEnemy)
        resources.enemies[13].lookToAngle(angleToSee: -225, timeTurning: 0)
        resources.enemies[13].run(.repeatForever(.sequence(resources.enemies[13].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -1280, y: 2720), typeOfEnemy: .commomEnemy)
        resources.enemies[14].lookToAngle(angleToSee: -45, timeTurning: 0)
        resources.enemies[14].run(.repeatForever(.sequence(resources.enemies[14].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 160, y: 2720), typeOfEnemy: .commomEnemy)
        resources.enemies[15].lookToAngle(angleToSee: -45, timeTurning: 0)
        resources.enemies[15].run(.repeatForever(.sequence(resources.enemies[15].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -1920, y: 8000), typeOfEnemy: .commomEnemy)
        resources.enemies[16].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[16].moveToX(xPos: -3200, timeWalking: 4)
        resources.enemies[16].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[16].moveToX(xPos: -1920, timeWalking: 4)
        resources.enemies[16].run(.repeatForever(.sequence(resources.enemies[16].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -3840, y: 7040), typeOfEnemy: .commomEnemy)
        resources.enemies[17].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[17].moveToX(xPos: -2240, timeWalking: 3)
        resources.enemies[17].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[17].moveToX(xPos: -3840, timeWalking: 3)
        resources.enemies[17].run(.repeatForever(.sequence(resources.enemies[17].toMove)), withKey: "MovementRoutine")
        
        
        resources.createEnemy(coordA: CGPoint(x: -1920, y: 6400), typeOfEnemy: .commomEnemy)
        resources.enemies[18].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[18].moveToX(xPos: -3200, timeWalking: 4)
        resources.enemies[18].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[18].moveToX(xPos: -1920, timeWalking: 3)
        resources.enemies[18].run(.repeatForever(.sequence(resources.enemies[18].toMove)), withKey: "MovementRoutine")
        
    }
}
