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
    var textBoxHasContent: Bool = false
    
    var isSaveMessageShowing = false
    var lblSaveGame = SKLabelNode()
    
    var isReadingTheWallShowing = false
    var lblReadWall = SKLabelNode()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOnMap(_ webcam: MainCamera) -> MainCamera {
        webcam.createTextBox()
        webcam.setScale(3.5)
        return webcam
    }
    
    func createTextBox() {
        let box = SKShapeNode(rectOf: CGSize(width: 750, height: 200))
        box.fillColor = .black
        box.position.y = -200
        box.zPosition = 10
        box.name = "hud_textbox"
        box.isHidden = true
        box.addChild(zORmToContinue())
        self.addChild(box)
    }
    
    private func zORmToContinue() -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Alagard")
        label.text = "Press Z or M to continue."
        label.color = .white
        label.fontSize = 16
        label.position = CGPoint(x: 270, y: -90)
        return label
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
    
    func interactWallMessage() {
        lblReadWall = SKLabelNode(fontNamed: "Alagard")
        lblReadWall.text = "Press Z or M to read the wall."
        if !isReadingTheWallShowing {
            let frameSize = 1024
            self.addChild(lblReadWall)
            lblReadWall.position = CGPoint(x: 0, y: -(frameSize / 3) + 30) // -275
            lblReadWall.zPosition = 100
            lblReadWall.name = "lblReadWall"
            isReadingTheWallShowing = true
        } else {
            self.childNode(withName: "lblReadWall")?.removeFromParent()
            isReadingTheWallShowing = false
        }
    }
}
