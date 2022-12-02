//
//  CombatButton.swift
//  Macro
//
//  Created by Paulo César on 19/10/22.
//

import Foundation
import SpriteKit

class CombatButton: SKSpriteNode {
    var mainText: SKLabelNode
    var shortcutText: SKLabelNode
    
    init(mainText: String, shortcut: String) {
        self.mainText = SKLabelNode()
        self.shortcutText = SKLabelNode()
        super.init(texture: nil, color: .white, size: CGSize(width: 150, height: 100))
        self.mainText = createMainText(string: mainText)
        self.shortcutText = createShortcutText(string: shortcut)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createMainText(string: String) -> SKLabelNode {
        let label = SKLabelNode()
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontName = "Alagard"
        label.fontColor = .black
        label.fontSize = 30
        label.text = string
        label.preferredMaxLayoutWidth = 130
        label.numberOfLines = 2
        label.position = CGPoint(x: 0, y: 0)
        self.addChild(label)
        return label
    }
    
    func createShortcutText(string: String) -> SKLabelNode {
        let label = SKLabelNode()
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.fontName = "Inter"
        label.fontColor = .gray
        label.text = string
        label.position = CGPoint(x: (self.size.width / 2) - 20, y: -(self.size.height / 2) + 20)
        self.addChild(label)
        return label
    }
    
    
}
