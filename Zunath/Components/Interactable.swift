//
//  Interactable.swift
//  Macro
//
//  Created by Gabriel do Prado Moreira on 22/09/22.
//

import Foundation
import SpriteKit

protocol Interactable {
    var isInsideArea: Bool { get set }
    var textContent: [String] { get set }
    func interact() -> Bool
}

extension Interactable where Self: InteractionArea {
    /// Called when the player interacts with an InteractionArea. If the area has text to be displayed, send a notification to the HUD with the InteractionArea's text array.
    /// - Returns: If there is text to be displayed, returns false to set the gameIsActive variable.
    func interact() -> Bool {
        if !self.textContent.isEmpty {
            NotificationCenter.default.post(name: Notification.Name("displayText"), object: nil, userInfo: ["strings": textContent])
            return false
        } else {
            return true
        }
    }
}
