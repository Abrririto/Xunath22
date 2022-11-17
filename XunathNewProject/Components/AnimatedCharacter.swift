
//
//  AnimatedCharacter.swift
//  Macro
//
//  Created by Paulo César on 07/10/22.
//

import Foundation
import SpriteKit

protocol AnimatedCharacter {
    var atlas:      SKTextureAtlas? { get set }
    var idleUp:     [SKTexture] { get set }
    var idleDown:   [SKTexture] { get set }
    var idleSide:   [SKTexture] { get set }
    var idleCombat: [SKTexture] { get set }
    var attackCombat: [SKTexture] { get set }
    var walkUp:     [SKTexture] { get set }
    var walkDown:   [SKTexture] { get set }
    var walkSide:   [SKTexture] { get set }
    var lastDirection: AnimationDirection? { get set }
    var currentDirection: AnimationDirection? { get set }
    
    func getAnimation(state: AnimationSet, direction: AnimationDirection?) -> [SKTexture]
    func playAnimation(state: AnimationSet, direction: AnimationDirection?, combatSprite: SKSpriteNode?)
    mutating func initializeAnimations()
}

class AnimatedCharacterClass: SKSpriteNode, AnimatedCharacter {
    var atlas: SKTextureAtlas?
    var idleUp: [SKTexture] = []
    var idleDown: [SKTexture] = []
    var idleSide: [SKTexture] = []
    var idleCombat: [SKTexture] = []
    var attackCombat: [SKTexture] = []
    var walkUp: [SKTexture] = []
    var walkDown: [SKTexture] = []
    var walkSide: [SKTexture] = []
    var lastDirection: AnimationDirection?
    var currentDirection: AnimationDirection?
    
    init() {
        super.init(texture: nil, color: .red, size: CGSize(width: 125, height: 125))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnimatedCharacter where Self: SKSpriteNode {
    func getAnimation(state: AnimationSet, direction: AnimationDirection?) -> [SKTexture] {
        var frames: [SKTexture] = []
        guard let atlas = atlas else { return frames }
        if let direction {
            let names = (atlas.textureNames.sorted()).filter({ $0.contains(state.rawValue) && $0.contains(direction.rawValue) })
            for frame in names { frames.append(SKTexture(imageNamed: frame)) }
            return frames
        } else {
            var names = atlas.textureNames.filter({ $0.contains(state.rawValue) })
            names.sort(by: { $0.localizedStandardCompare($1) == .orderedAscending })
            for frame in names { frames.append(SKTexture(imageNamed: frame)) }
            return frames
        }
    }
    
    func playAnimation(state: AnimationSet, direction: AnimationDirection? = nil, combatSprite: SKSpriteNode? = nil) {
        self.removeAction(forKey: "spriteAnimation")
        switch state {
        case .idle:
            guard let direction else { return }
            switch direction {
            case .up: self.run(.repeatForever(.animate(with: self.idleUp, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .down: self.run(.repeatForever(.animate(with: self.idleDown, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .side: self.run(.repeatForever(.animate(with: self.idleSide, timePerFrame: 0.1)), withKey: "spriteAnimation")
            }
        case .walk:
            guard let direction else { return }
            switch direction {
            case .up: self.run(.repeatForever(.animate(with: self.walkUp, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .down: self.run(.repeatForever(.animate(with: self.walkDown, timePerFrame: 0.1)), withKey: "spriteAnimation")
            case .side: self.run(.repeatForever(.animate(with: self.walkSide, timePerFrame: 0.1)), withKey: "spriteAnimation")
            }
        case .combat_idle:
            guard let combatSprite else { return }
            combatSprite.run(.repeatForever(.animate(with: self.idleCombat, timePerFrame: 0.1)), withKey: "combatAnimation")
        case .combat_attack:
            guard let combatSprite else { return }
            combatSprite.run(.animate(with: self.attackCombat, timePerFrame: 0.1), completion: { self.playAnimation(state: .combat_idle, direction: nil, combatSprite: combatSprite) })
        }
    }
    
    mutating func initializeAnimations() {
        self.idleUp.append(contentsOf: self.getAnimation(state: .idle, direction: .up))
        self.idleDown.append(contentsOf: self.getAnimation(state: .idle, direction: .down))
        self.idleSide.append(contentsOf: self.getAnimation(state: .idle, direction: .side))
        self.walkUp.append(contentsOf: self.getAnimation(state: .walk, direction: .up))
        self.walkDown.append(contentsOf: self.getAnimation(state: .walk, direction: .down))
        self.walkSide.append(contentsOf: self.getAnimation(state: .walk, direction: .side))
        self.idleCombat.append(contentsOf: self.getAnimation(state: .combat_idle, direction: nil))
        self.attackCombat.append(contentsOf: self.getAnimation(state: .combat_attack, direction: nil))
    }
}

extension AnimatedCharacter where Self: MainCharacter {
    /// Response the correct animation if the player is walking or stopped (pressing two opposite keys).
    /// - Parameter event: Observable that see if the player pressed or released a key.
    mutating func makeTheCorrectAnimationRun(event: NSEvent) {
        if !event.isARepeat && self.currentDirection != nil {
            self.playAnimation(state: .walk, direction: isWalkingAnimation())
        }
        if self.movementController.count == 2 && !event.isARepeat &&
            ((self.movementController.contains(1) && self.movementController.contains(2)) ||
             (self.movementController.contains(3) && self.movementController.contains(4))) {
            self.playAnimation(state: .idle, direction: .down)
        }
    }
    
    /// Verify if the player is not moving.
    mutating func isStoppedAnimation() {
        if movementController.isEmpty {
            self.playAnimation(state: .idle, direction: self.currentDirection ?? .down)
        }
    }
    
    /// Verify if exist some value on array.
    /// - Returns: Return the correspondent animation.
    func isWalkingAnimation() -> AnimationDirection {
        switch !self.movementController.isEmpty {
        case self.movementController.contains(1): return .up
        case self.movementController.contains(2): return .down
        case self.movementController.contains(3), self.movementController.contains(4): return .side
        default: return .down
        }
    }
}
