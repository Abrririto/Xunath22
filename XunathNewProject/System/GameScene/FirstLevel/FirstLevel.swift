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
    private var textControl: [Int:String] = [:]
    private var intermediateTextControl: Int = 0
    
    //    var enemies = [Enemy]()
    
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
        //        if let node = self.childNode(withName: "SavePortal2") as? SKSpriteNode {
        //            createSavePortal(node)
        //        }
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
        guard playerIsBodyA != nil else { return }
        checkSaveContact(contact: contact)
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
}

enum MapConfigTypes: String {
    case setCollision
    case setDesignAdjust
    case setInteraction
}
