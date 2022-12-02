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
                CombatSceneView()
                    .environmentObject(viewModel)
            case .SecondLevel:
                SecondLevelView()
                    .environmentObject(viewModel)
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

enum SceneList: String, Codable {
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
    
    lazy var firstLevel: FirstLevel = {
        let scene = GKScene(fileNamed: "FirstLevel")
        if let sceneNode = scene?.rootNode as? FirstLevel {
            sceneNode.size = Size.screenSize
            sceneNode.scaleMode = .aspectFill
            return sceneNode
        }
        return FirstLevel()
    }()
    
    lazy var secondLevel: SecondLevel = {
        let scene = GKScene(fileNamed: "SecondLevel")
        if let sceneNode = scene?.rootNode as? SecondLevel {
            sceneNode.size = Size.screenSize
            sceneNode.scaleMode = .aspectFill
            return sceneNode
        }
        return SecondLevel()
    }()
    
    
    func changeScene(scene: SceneList) {
        switch scene {
        case .MainMenu, .CombatScene:
            self.scene = scene
        case .FirstLevel, .SecondLevel, .ThirdLevel:
            self.scene = scene
            Level.scene = scene
        }
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
    
    
    func changeSceneFromOutside(scene: SceneList) {
        changeScene(scene: scene)
    }
    
}
