//
//  Collision.swift
//  XunathNewProject
//
//  Created by Arthur Martins Saraiva on 22/11/22.
//

import SpriteKit

struct Collision {
    static func create(_ tileMap: SKTileMapNode, col: Int, row: Int) -> SKSpriteNode {
        let tileNode = SKSpriteNode()
        tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 200))
        tileNode.physicsBody?.affectedByGravity = false
        tileNode.physicsBody?.allowsRotation = false
        tileNode.physicsBody?.isDynamic = false
        tileNode.position = tileMap.centerOfTile(atColumn: col, row: row)
        tileNode.position = (CGPoint(x: tileNode.position.x, y: tileNode.position.y + 40))
        return tileNode
    }
}
