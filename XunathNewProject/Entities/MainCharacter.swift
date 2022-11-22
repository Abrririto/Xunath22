//
//  Character.swift
//  Macro
//
//  Created by Paulo César on 13/09/22.
//

import Foundation
import SpriteKit

class MainCharacter: AnimatedCharacterClass, PlayerControllable, Collidable, CombatAttributes, CombatSkillsPlayer {
    // Combat Attributes
    var maxHealth: Int = 0
    var currentHealth: Int = 0
    var maxMana: Int = 0
    var currentMana: Int = 0
    var attack: Int = 0
    var defense: Int = 0
    var agility: Int = 0
    var maxExperience: Int = 0
    var currentExperience: Int = 0
    var level: Int {
        didSet {
            self.maxHealth = self.maxHealth + (25 * level)
            self.maxMana = self.maxMana + (level % 2 == 0 ? 1 : 0)
            self.currentHealth = self.maxHealth
            self.currentMana = self.maxMana
            self.attack = 10 + Int(ceil(2.5 * Double(self.level)))
            self.defense = 10 + (2 * self.level)
            self.agility = 10 + self.level
            self.currentExperience = 0
            self.maxExperience = 100 + Int(ceil(10 * sqrt(11 * Double(self.level))))
        }
    }
    
    var combatSprite: SKSpriteNode = SKSpriteNode(color: .purple, size: CGSize(width: 200, height: 300))
    
    // Movement
    var movementController: Set<Int>
    var maxVelocity: CGFloat
    var hitBox: SKPhysicsBody

    override init() {
        self.level = -1
        self.movementController = []
        self.maxVelocity = 13
        self.hitBox = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 40))
        super.init()
        atlas = SKTextureAtlas(named: "MainCharacter")
        self.hitBox.affectedByGravity = false
        self.hitBox.isDynamic = true
        self.hitBox.allowsRotation = false
        self.zPosition = 5
        self.hitBox.categoryBitMask = BitMasks.player.rawValue
        self.hitBox.collisionBitMask = BitMasks.wall.rawValue + BitMasks.enemy.rawValue
        self.hitBox.contactTestBitMask = BitMasks.enemyVision.rawValue + BitMasks.collectable.rawValue + BitMasks.interactable.rawValue + BitMasks.endBlock.rawValue
        
        self.physicsBody = hitBox
        self.anchorPoint = CGPoint(x: 0.5, y: 0.2)
        self.name = "MainCharacter"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func levelUp() {
        self.maxHealth = 100
        self.maxMana = 9
        self.level += 1
    }
    
    func setLevelTo(_ level: Int) {
        self.level = level
    }
    
    func setOnMap(_ character: MainCharacter) -> MainCharacter{
        character.setScale(3)
        character.position = CGPoint(x: -17920, y: 8320)
        character.playAnimation(state: .idle, direction: .down)
        character.levelUp()
        return character
    }
    
}
