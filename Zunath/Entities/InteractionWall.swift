//
//  InteractionWall.swift
//  XunathNewProject
//
//  Created by Arthur Martins Saraiva on 25/11/22.
//

import Foundation
import SpriteKit

struct InteractionWall {
    func checkPosition(_ tileMap: SKTileMapNode,_ firstBlockPosition: inout CGPoint?,_ countBlocks: inout CGFloat, col: Int, row: Int) {
        countBlocks += 1
        if firstBlockPosition == nil {
            firstBlockPosition = tileMap.centerOfTile(atColumn: col, row: row)
        }
    }
    
    func create(_ interactionNumber: inout Int,_ firstBlockPosition: inout CGPoint?,_ countBlocks: inout CGFloat) -> SKSpriteNode? {
        guard let blockPosition = firstBlockPosition else { return nil }
        let size = CGSize(width: countBlocks * 200, height: 200)
        let middleXPos = (countBlocks * 200)/2
        let xPos = (blockPosition.x - 100) + middleXPos
        let yPos = blockPosition.y - 100
        let node = createSKNodeInt(size: size, position: CGPoint(x: xPos, y: yPos))
        interactionNumber += 1
        countBlocks = 0
        firstBlockPosition = nil
        return node
    }
    
    private func createSKNodeInt(size: CGSize, position: CGPoint) -> SKSpriteNode {
        let tileNode = SKSpriteNode(color: .clear, size: size)
        tileNode.physicsBody = SKPhysicsBody(rectangleOf: tileNode.size)
        tileNode.physicsBody?.isDynamic = false
        tileNode.physicsBody?.contactTestBitMask = BitMasks.player.rawValue
        tileNode.physicsBody?.categoryBitMask = BitMasks.interactable.rawValue
        tileNode.position = position
        return tileNode
    }
}
