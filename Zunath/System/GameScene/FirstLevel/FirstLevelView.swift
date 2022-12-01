//
//  GameSceneView.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 21/10/22.
//

import SwiftUI
import SpriteKit
import GameplayKit

protocol GameSceneProtocol {
    func changeScene(scene: SceneList)
}

struct FirstLevelView: View {
    
    @EnvironmentObject var sceneManagerViewModel: SceneManagerViewModel
    
    @FocusState var focus: Bool
    
    var body: some View {
        ZStack {
            SpriteView(scene: sceneManagerViewModel.firstLevel)
                .focused($focus)
                .onAppear {
                    sceneManagerViewModel.firstLevel.gameSceneDelegate = self
                    focus = true
                }
        }
    }
}

extension FirstLevelView: GameSceneProtocol {
    func changeScene(scene: SceneList) {
        sceneManagerViewModel.changeScene(scene: scene)
    }
}




//struct GameSceneView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameSceneView()
//    }
//}
