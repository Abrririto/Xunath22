//
//  MainCamera.swift
//  Macro
//
//  Created by Paulo César on 16/09/22.
//

// swiftlint:disable trailing_whitespace

import Foundation
import SpriteKit

class MainCamera: SKCameraNode {
    private var hud: [String: SKNode] = [:]

    var textBoxHasContent: Bool = false
    var isSaveMessageShowing = false
    var lblSaveGame = SKLabelNode()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resolutionWasUpdated(notification:)),
                                               name: NSApplication.didChangeScreenParametersNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.textBoxSetup(notification:)),
                                               name: Notification.Name("displayText"),
                                               object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOnMap(_ webcam: MainCamera) -> MainCamera {
        webcam.createInteraction()
        webcam.createTextBox()
        webcam.setScale(5.0)
        return webcam
    }
    
    func createInteraction() {
        let interact = SKLabelNode(text: "Press Z or M to interact")
        let frameSize = 100
        interact.name = "hud_interact"
        interact.verticalAlignmentMode = .center
        interact.horizontalAlignmentMode = .center
        interact.position = CGPoint(x: 0, y: -(frameSize / 3) + 30) // -275
        interact.zPosition = 10
        interact.isHidden = true
        self.hud["hud_interact"] = interact
        self.addChild(interact)
    }
    
    func createTextBox() {
        let box = TextBox(texture: nil, color: .black, size: CGSize(width: 750, height: 200))
        box.position.y = -200
        box.zPosition = 10
        box.name = "hud_textbox"
        box.isHidden = true
        self.hud["hud_textbox"] = box
        self.addChild(box)
    }
    
    func interactSaveMessage() {
        lblSaveGame = SKLabelNode(fontNamed: "Alagard")
        lblSaveGame.text = "Press Z to Save Game!"
        if !isSaveMessageShowing {
            
            let frameSize = 1024
            self.addChild(lblSaveGame)
            lblSaveGame.position = CGPoint(x: 0, y: -(frameSize / 3) + 30) // -275
            lblSaveGame.zPosition = 100
            lblSaveGame.name = "lblSaveGame"
            isSaveMessageShowing = true
        } else {
            self.childNode(withName: "lblSaveGame")?.removeFromParent()
            isSaveMessageShowing = false
        }
    }
    
    @objc func resolutionWasUpdated(notification: Notification) {
        print("Resolution was altered")
    }
    
    func fetchHudAsset(_ name: String) -> SKNode? {
        return hud[name]
    }
    
    func toggleInteractionHUDNotification(contact: Bool) {
        guard let asset = fetchHudAsset("hud_interact") else { return }
        contact ? (asset.isHidden = false) : (asset.isHidden = true)
    }
    
    /// Gets the strings of text from the Interactable and gives it to the Text Box
    /// - Parameter notification: Notification containing the array of strings to be displayed.
    @objc func textBoxSetup(notification: Notification) {
        if let strings = notification.userInfo?["strings"] as? [String], let box = hud["hud_textbox"] as? TextBox {
            box.addTextToBeDisplayed(text: strings)
            self.textBoxHasContent = true
            self.displayTextBox()
        }
    }
    
    /// If the textBox has content to display, it runs displayNextString
    /// - Returns: Game's active state. If there is still content to be displayed, returns false to keep the game logic temporarily disabled.
    func displayTextBox() -> Bool {
        if let box = hud["hud_textbox"] as? TextBox {
            self.textBoxHasContent = box.displayNextString()
        }
        
        if textBoxHasContent {
            return false
        } else {
            return true
        }
    }
}
