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
    var gameSceneDelegate: GameSceneProtocol?
    private var textControl: [Int:String] = [:]
    private var intermediateTextControl: Int = 0
    
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
        //        AudioPlayerImpl.shared.play(music: Audio.MusicFiles.exploracao)
    }
    
    override func didMove(to view: SKView) {
        AudioPlayerImpl.shared.play(music: Audio.MusicFiles.exploracao)
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
    
    func readText() -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Alagard")
        label.text = textControl[self.intermediateTextControl]
        label.color = .white
        label.preferredMaxLayoutWidth = 735
        label.numberOfLines = 4
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .top
        label.position = CGPoint(x: -365, y: 75)
        label.name = "text"
        return label
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case InteractKeybinds.INTERACT.rawValue,
            InteractKeybinds.ALTERNATIVEINTERACT.rawValue:
            if webcam.isSaveMessageShowing {
                SaveManager.shared.saveGame()
                return
            }
            if webcam.isReadingTheWallShowing && !self.isPaused {
                webcam.childNode(withName: "hud_textbox")?.isHidden = false
                webcam.lblReadWall.isHidden = true
                self.isPaused = true
                for text in textControl {
                    if text.key == intermediateTextControl {
                        webcam.childNode(withName: "hud_textbox")?.addChild(readText())
                    }
                }
                return
            } else if webcam.isReadingTheWallShowing && self.isPaused {
                self.isPaused = false
                webcam.childNode(withName: "hud_textbox")?.isHidden = true
                webcam.childNode(withName: "hud_textbox")?.childNode(withName: "text")?.removeFromParent()
            }
            
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
            guard let bodyA = contact.bodyA.node?.parent as? Enemy else { return }
            //            character.removeFromParent()
            //            character.clearMovementBuffer()
            //            gameSceneDelegate?.changeScene(scene: .SecondLevel)
            EnemyThatSeenCharEnum.lastSeenEnemy = bodyA
            character.clearMovementBuffer()
            gameSceneDelegate?.changeScene(scene: .CombatScene)
            self.isPaused = true
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
        for row in 0..<tileMap.numberOfRows {
            for col in 0..<tileMap.numberOfColumns {
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
                        let count = textControl.count
                        textControl[node.hash] = FirstLevelWords().AllTexts[count]
                        node.name = "\(node.hash)"
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
            webcam.interactWallMessage()
            guard let string = contact.bodyB.node?.name else { return }
            intermediateTextControl = Int(string) ?? 0
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
        resources.createEnemy(coordA: CGPoint(x: -14080, y: 7040), typeOfEnemy: .commomEnemy)
        resources.enemies[0].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[0].moveToX(xPos: -9280, timeWalking: 8)
        resources.enemies[0].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[0].moveToX(xPos: -14080, timeWalking: 8)
        resources.enemies[0].run(.repeatForever(.sequence(resources.enemies[0].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -15120, y: 8560), typeOfEnemy: .commomEnemy)
        resources.enemies[1].lookToAngle(angleToSee: -225, timeTurning: 0)
        resources.enemies[1].run(.repeatForever(.sequence(resources.enemies[1].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -12480, y: 2560), typeOfEnemy: .commomEnemy)
        resources.enemies[2].lookToAngle(angleToSee: -135, timeTurning: 0)
        resources.enemies[2].run(.repeatForever(.sequence(resources.enemies[2].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -5440, y: 6240), typeOfEnemy: .commomEnemy)
        resources.enemies[3].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[3].moveToX(xPos: -1920, timeWalking: 6)
        resources.enemies[3].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[3].moveToX(xPos: -5440, timeWalking: 6)
        resources.enemies[3].run(.repeatForever(.sequence(resources.enemies[3].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 3040, y: 6240), typeOfEnemy: .commomEnemy)
        resources.enemies[4].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[4].moveToX(xPos: -960, timeWalking: 6)
        resources.enemies[4].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[4].moveToX(xPos: 3040, timeWalking: 6)
        resources.enemies[4].run(.repeatForever(.sequence(resources.enemies[4].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 1400, y: 4320), typeOfEnemy: .commomEnemy)
        resources.enemies[5].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[5].moveToX(xPos: -5600, timeWalking: 10)
        resources.enemies[5].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[5].moveToX(xPos: 1400, timeWalking: 10)
        resources.enemies[5].run(.repeatForever(.sequence(resources.enemies[5].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -4640, y: 2160), typeOfEnemy: .commomEnemy)
        resources.enemies[6].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[6].moveToX(xPos: -1920, timeWalking: 10)
        resources.enemies[6].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[6].moveToX(xPos: -4640, timeWalking: 10)
        resources.enemies[6].run(.repeatForever(.sequence(resources.enemies[6].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 1520, y: -1440), typeOfEnemy: .commomEnemy)
        resources.enemies[7].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[7].moveToX(xPos: 720, timeWalking: 6)
        resources.enemies[7].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[7].moveToX(xPos: 1520, timeWalking: 6)
        resources.enemies[7].run(.repeatForever(.sequence(resources.enemies[7].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 0, y: 0), typeOfEnemy: .commomEnemy)
        resources.enemies[8].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[8].moveToX(xPos: 2240, timeWalking: 6)
        resources.enemies[8].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[8].moveToX(xPos: 0, timeWalking: 8)
        resources.enemies[8].run(.repeatForever(.sequence(resources.enemies[8].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -6240, y: -1840), typeOfEnemy: .commomEnemy)
        resources.enemies[9].lookToAngle(angleToSee: -315, timeTurning: 0.7)
        resources.enemies[9].moveToX(xPos: -10000, timeWalking: 8)
        resources.enemies[9].lookToAngle(angleToSee: -135, timeTurning: 0.7)
        resources.enemies[9].moveToX(xPos: -6240, timeWalking: 8)
        resources.enemies[9].run(.repeatForever(.sequence(resources.enemies[9].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -6160, y: 5500), typeOfEnemy: .commomEnemy)
        resources.enemies[10].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[10].moveToY(yPos: 2700, timeWalking: 6)
        resources.enemies[10].lookToAngle(angleToSee: -45, timeTurning: 0.7)
        resources.enemies[10].moveToY(yPos: 5500, timeWalking: 6)
        resources.enemies[10].run(.repeatForever(.sequence(resources.enemies[10].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: 2960, y: 240), typeOfEnemy: .commomEnemy)
        resources.enemies[11].lookToAngle(angleToSee: -45, timeTurning: 0.7)
        resources.enemies[11].moveToY(yPos: 4480, timeWalking: 8)
        resources.enemies[11].lookToAngle(angleToSee: -225, timeTurning: 0.7)
        resources.enemies[11].moveToY(yPos: 240, timeWalking: 8)
        resources.enemies[11].run(.repeatForever(.sequence(resources.enemies[11].toMove)), withKey: "MovementRoutine")
        
        resources.createEnemy(coordA: CGPoint(x: -80, y: -4960), typeOfEnemy: .commomEnemy)
        resources.enemies[12].lookToAngle(angleToSee: 0, timeTurning: 0)
        resources.enemies[12].run(.repeatForever(.sequence(resources.enemies[12].toMove)), withKey: "MovementRoutine")
    }
}

enum MapConfigTypes: String {
    case setCollision
    case setDesignAdjust
    case setInteraction
}
