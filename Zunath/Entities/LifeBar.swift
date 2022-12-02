//
//  LifeBar.swift
//  Macro
//
//  Created by Arthur Martins Saraiva on 10/10/22.
//

import Foundation
import SpriteKit

class LifeBar: SKSpriteNode {
    var valueOfLife: Int
    
    init(_ valueOfLife: Int){
        self.valueOfLife = valueOfLife
        super.init(texture: nil, color: .black, size: CGSize(width: 250, height: 25))
        self.name = "gray-bar"
        self.addChild(updateLifeBar(lifePercentage: valueOfLife))
    }
    
    private func updateLifeBar(lifePercentage: Int) -> SKSpriteNode {
        let lifeBar = SKSpriteNode(texture: nil, color: .systemGreen, size: CGSize(width: 240, height: 15))
        lifeBar.name = "life-bar"
        lifeBar.addChild(addText(text_: "\(lifePercentage)%"))
        return lifeBar
    }
    
    private func addText(text_: String) -> SKLabelNode {
        let text = SKLabelNode(fontNamed: "Apple Symbols")
        text.text = text_
        text.numberOfLines = 1
        text.fontSize = 12
        text.fontColor = .systemIndigo
        text.position = CGPoint(x: frame.midX, y: frame.midY - text.frame.width/4 + 2)
        return text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
