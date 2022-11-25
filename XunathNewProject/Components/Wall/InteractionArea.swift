//
//  StoryWall.swift
//  Macro
//
//  Created by Gabriel do Prado Moreira & Paulo César de Lima Rocha on 22/09/22.
//

import Foundation
import SpriteKit

class InteractionArea: SKShapeNode, Interactable, Collidable {
    var hitBox: SKPhysicsBody
    var isInsideArea: Bool = false
    var textContent: [String]
    
    init(node: SKSpriteNode, size: CGSize, textContent: [String]) {
        self.hitBox = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height + (size.height / 2)))
        self.textContent = textContent
        super.init()
        self.alpha = 0
        self.hitBox.isDynamic = false
        self.hitBox.categoryBitMask = BitMasks.interactable.rawValue
        self.hitBox.contactTestBitMask = BitMasks.player.rawValue
        self.physicsBody = hitBox
        self.position = node.position
        self.position.y -= node.size.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
