//
//  Enemy.swift
//  Macro
//
//  Created by Arthur Martins Saraiva on 15/09/22.
//

import Foundation
import SpriteKit

class Enemy: SKNode, Collidable, KindOfEnemy, FlyweightAnimatedEnemy, CombatAttributes, CombatSkillsEnemy {
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
            self.attack = 10 + Int(ceil(1.5 * Double(self.level)))
            self.defense = 10 + (2 * self.level)
            self.agility = 10 + self.level
            self.currentExperience = 0
            self.maxExperience = 100 + Int(ceil(10 * sqrt(11 * Double(self.level))))
        }
    }
    
    var hasBeenDefeated: Bool = false
    
    // Animations
    var flyweight: EnemyFlyweight?
    var lastPos: CGPoint
    
    // Sprites
    var combatSprite: SKSpriteNode = SKSpriteNode(color: .red, size: CGSize(width: 250, height: 300))
    var worldSprite: SKSpriteNode
    
    // Open World Animation
    var lastDirection: AnimationDirection?
    var currentDirection: AnimationDirection?
    
    // Collision & General Info
    var typeOfEnemy: EnemyTypes
    var takenDamage: Int
    var percentualLife: Int
    var hitBox: SKPhysicsBody
    var hasDetectedPlayer: Bool
    var toMove: [SKAction] = []
    private var vision: SKShapeNode { getEnemyVision(angle: 90, size: 250, color: .black, name: "vision", visionAngle)}
    var visionAngle: Double
    
    init(_ typeOfEnemy: EnemyTypes, _ flyweight: EnemyFlyweight) {
        self.visionAngle = 45
        self.hasDetectedPlayer = false
        self.hitBox = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 125))
        self.takenDamage = 0
        self.typeOfEnemy = typeOfEnemy
        self.percentualLife = typeOfEnemy.life
//        self.flyweight = flyweight
        self.worldSprite = SKSpriteNode(texture: SKTexture(imageNamed: "common_idle_down"), color: .red, size: CGSize(width: 125, height: 125))
        self.level = 0
        self.lastPos = CGPoint(x: 0, y: 0)
        super.init()
        self.lastPos = self.position
        self.addChild(vision)
        self.addChild(worldSprite)
        enemyColisionConfigs()
        self.setScale(4)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This function actives colision of enemy's body.
    private func enemyColisionConfigs() {
        hitBox.collisionBitMask = BitMasks.player.rawValue + BitMasks.wall.rawValue
        hitBox.categoryBitMask = BitMasks.enemy.rawValue
        
        hitBox.isDynamic = false
        hitBox.allowsRotation = false
        self.worldSprite.physicsBody = hitBox
        
    }
    
    func setCombatLevel(_ level: Int) {
        self.level = level
    }
}
