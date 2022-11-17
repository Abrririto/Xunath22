//
//  TextBox.swift
//  Macro
//
//  Created by Paulo César on 29/09/22.
//

import Foundation
import SpriteKit

class TextBox: SKSpriteNode {
    let label = SKLabelNode()
    private var toBeDisplayed: [String] = []
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.label.attributedText = AttributedStringGenerator.shared.createAttributedString(text: "A")
        self.label.horizontalAlignmentMode = .left
        self.label.verticalAlignmentMode = .center
        self.label.numberOfLines = 5
        self.addChild(label)
        self.label.position.x = -355
        self.label.position.y = 0 // 80
        self.label.preferredMaxLayoutWidth = 705
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Gets text from Interactable and prepares it to be displayed.
    /// - Parameter text: Interactable's string array.
    func addTextToBeDisplayed(text: [String]) {
        self.toBeDisplayed = text
    }
    
    /// If there is something to be displayed, get the first string from the array, turn it into an Attributed String and display on the Text Box. If there's nothing left, hide the Text Box.
    /// - Returns: Defines if there is still something to be displayed.
    func displayNextString() -> Bool {
        if !toBeDisplayed.isEmpty {
            let text = toBeDisplayed.removeFirst()
            if self.isHidden {
                self.isHidden = false
            }
            self.label.attributedText = AttributedStringGenerator.shared.createAttributedString(text: text)
            return true
        }
        
        print(toBeDisplayed)
        self.isHidden = true
        return false
    }
}
