//
//  SceneManager.swift
//  XunathNewProject
//
//  Created by Gabriel do Prado Moreira on 28/11/22.
//

import Foundation
import SpriteKit
import SwiftUI
import GameplayKit

struct SceneManager: View {
    @StateObject var viewModel: SceneManagerViewModel = SceneManagerViewModel()
    
    var body: some View {
        switch viewModel.scene {
            case .MainMenu:
                MainMenuView()
                    .environmentObject(viewModel)
            case .FirstLevel:
                FirstLevelView()
                    .environmentObject(viewModel)
            case .CombatScene:
                EmptyView()
            case .SecondLevel:
                EmptyView()
            case .ThirdLevel:
                EmptyView()
        }
    }
        
}

struct SceneManager_Previews: PreviewProvider {
    static var previews: some View {
        SceneManager()
    }
}

enum SceneList: String {
    case MainMenu
    case FirstLevel
    case SecondLevel
    case ThirdLevel
    case CombatScene
}
protocol SceneChangeable {
    func changeScene(scene: SceneList)
}

class SceneManagerViewModel: ObservableObject, SceneChangeable {
    @Published var scene: SceneList = .MainMenu
    
    @Published var firstLevel: FirstLevel = {
        let scene = GKScene(fileNamed: "FirstLevel")
        if let sceneNode = scene?.rootNode as? FirstLevel {
            sceneNode.size = Size.screenSize
            sceneNode.scaleMode = .aspectFill
            return sceneNode
        }
        return FirstLevel()
    }()
    
    func changeScene(scene: SceneList) {
        self.scene = scene
    }
    
    func newGame() {
        if SaveManager.shared.checkIfSaveExists() {
            SaveManager.shared.clearGameData()
        }
        changeScene(scene: .FirstLevel)
    }
    
    func loadGame() {
        if SaveManager.shared.checkIfSaveExists() {
            return
        }
        SaveManager.shared.sceneManagerDelegate = self
        SaveManager.shared.loadSavedData {
            //
        }
    }
    
    
    func changeSceneFromOutsideSwiftUI(scene: SceneList) {
        changeScene(scene: scene)
    }
    
}
