//
//  EnemyVision.swift
//  Macro
//
//  Created by Arthur Martins Saraiva on 19/09/22.
//

import Foundation
import SpriteKit

extension Enemy {
    
    /// A function that returns a shape of enemy's vision.
    /// - Returns: CGMutablePath.
    /// - Parameters:
    ///   - angle: The angle of vision the vision.
    ///   - size: The size of how far is the vision.
    private func enemyVisionShape(_ angle: Double, _ size: Double) -> CGMutablePath {
        
        let path = CGMutablePath()
        let convertAngle = angle * .pi/180
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(center: CGPoint(x: 0, y: 0),
                    radius: size,
                    startAngle: 3.14,
                    endAngle: 3.14 - convertAngle,
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
    
    /// A function that actives configs of  a vision shape.
    /// - Parameter sprite: The SKShapeNode that will be the vision.
    /// - Parameter color: The color of the vision.
    /// - Parameter visionAngle: The angle of eye's vision.
    /// - Parameter nome: The name of that part of the vision
    private func enemyVisionShapeConfigs(_ sprite: SKShapeNode, _ color: NSColor, _ nome: String, _ visionAngle: Double) {
        let angle = -(visionAngle * (.pi/180))
        sprite.position = CGPoint(x: 0, y: 0)
        sprite.fillColor = color
        sprite.name = nome
        sprite.zRotation = angle
        sprite.zPosition = -1
    }
    
    /// This function enables the enemy to "see". It configure colision and vision.
    /// - Parameter sprite: The SKShapeNode that will be the vision.
    /// - Parameter path: The path of vision in SKShapeNode.
    private func enemyVisionColisionConfigs(_ sprite: SKShapeNode, path: CGPath) {
        sprite.physicsBody = SKPhysicsBody(edgeLoopFrom: path)
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.contactTestBitMask = BitMasks.player.rawValue
        sprite.physicsBody?.categoryBitMask = BitMasks.enemyVision.rawValue
    }
    
    /// This function is the visions of the enemy.
    /// - Parameters:
    ///   - angle: The angle of vision
    ///   - size: How far you can see
    ///   - color: Which color will be what you are seeing.
    ///   - name: The name of the vision shape.
    ///   - visionAngle: Where are you looking for.
    /// - Returns: SKShapeNode.
    func getEnemyVision(angle: Double, size: Double, color: NSColor, name: String,_ visionAngle: Double) -> SKShapeNode {
        let sprite = SKShapeNode(path: enemyVisionShape(angle, size))
        enemyVisionShapeConfigs(sprite, color, name, visionAngle)
        enemyVisionColisionConfigs(sprite, path: enemyVisionShape(angle, size))
        return sprite
    }
    
}
