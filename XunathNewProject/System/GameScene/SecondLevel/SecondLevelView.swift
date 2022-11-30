//
//  GameSceneView.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 21/10/22.
//

import SwiftUI
import SpriteKit
import GameplayKit

struct SecondLevelView: View {
    
    @EnvironmentObject var sceneManagerViewModel: SceneManagerViewModel
    
    @FocusState var focus: Bool
    
    var body: some View {
        ZStack {
            SpriteView(scene: sceneManagerViewModel.secondLevel)
                .focused($focus)
                .onAppear {
//                    scene.gameSceneDelegate = self
                    focus = true
                }
        }
    }
}

extension SecondLevelView: GameSceneProtocol {
    func changeScene(scene: SceneList) {
        sceneManagerViewModel.changeScene(scene: scene)
    }
}




//struct GameSceneView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameSceneView()
//    }
//}
