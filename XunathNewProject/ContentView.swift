//
//  ContentView.swift
//  XunathNewProject
//
//  Created by Arthur Martins Saraiva on 16/11/22.
//

import SwiftUI
import SpriteKit
import GameplayKit

struct ContentView: View {
    @State var scene: FirstLevel = {
        let scene = GKScene(fileNamed: "FirstLevel")
        if let sceneNode = scene?.rootNode as? FirstLevel {
            sceneNode.size = CGSize(width: 1024, height: 768)
            sceneNode.scaleMode = .aspectFill
            return sceneNode
        }
        return FirstLevel()
    }()
    
    @FocusState var focus: Bool
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
