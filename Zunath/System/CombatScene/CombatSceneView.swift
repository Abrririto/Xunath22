//
//  CombatSceneViewModel.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 21/10/22.
//

import SwiftUI
import SpriteKit

struct CombatSceneView: View {
    //    var enemies: [EnemyTypes]
    
    @StateObject var combatViewModel = CombatViewModel()
    @State var eruptionHasEnoughMana = true
    @State var healHasEnoughMana = true
    @State var healthPercentage: Float = 0.0
    @State var manaPercentage: Float = 0.0
    @State var buttonEnabled = true {
        didSet {
            if !buttonEnabled {
                eruptionHasEnoughMana = false
                healHasEnoughMana = false
            } else {
                verifyMana(actualMana: Resources.mainCharacter.currentMana)
            }
        }
    }
    
//    @State var eruptionEnabled: Bool
//    @State var healEnabled: Bool
    @EnvironmentObject var viewModel: SceneManagerViewModel
    @FocusState var focus: Bool
    let combatScene = CombatScene(enemiesAvailable: [.commomEnemy], viewModel: CombatViewModel())
    
    
    var body: some View {
        ZStack {
            
//            eruptionEnabled = (buttonEnabled && eruptionHasEnoughMana)
//            healEnabled = (buttonEnabled && healHasEnoughMana)
            
            SpriteView(scene: combatScene)
                
            GeometryReader { geometry in
                VStack(spacing: 1) {
//                    ZStack(alignment: .leading) {
//                        Text("\(combatScene.character.currentHealth) / \(combatScene.character.maxHealth)")
//                            .zIndex(1)
//                            .padding([.horizontal], 10)
//                            .font(.custom("Alagard", size: 20))
//                        RoundedRectangle(cornerRadius: 5)
//                            .foregroundColor(.gray)
//                            .frame(width: 400, height: 40)
//
//                        RoundedRectangle(cornerRadius: 5)
//                            .foregroundColor(.red)
//                            .frame(width: 400 * healthPercentage, height: 40)
//                    }
                    StatusBarView(barType: .health, percentage: $healthPercentage)
                        .padding(.top, -20)
                    
//                    ZStack(alignment: .leading) {
//                        Text("\(combatScene.character.currentMana) / \(combatScene.character.maxMana)")
//                            .zIndex(1)
//                            .padding([.horizontal], 10)
//                            .font(.custom("Alagard", size: 20))
//                        RoundedRectangle(cornerRadius: 5)
//                            .foregroundColor(.gray)
//                            .frame(width: 400, height: 20)
//                        RoundedRectangle(cornerRadius: 5)
//                            .foregroundColor(.blue)
//                            .frame(width: 400 * manaPercentage, height: 20)
//                    }
                    StatusBarView(barType: .mana, percentage: $manaPercentage)
                        .padding(.top, -20)
                }
                .scaleEffect(1.5, anchor: .topLeading)
                .position(x: geometry.frame(in: .local).midX / 3.75, y: geometry.frame(in: .local).midY / 4)
                
                HStack {
                    
                    if combatViewModel.selectedHUD {
                        CombatButtonSUI(mainText: "Focus Punch", shortcutText: "H", isEnabled: $buttonEnabled, action:
                        {
                            focus = true
                            lockButtons()
                            AudioPlayerImpl.shared.play(effect: Audio.EffectFiles.button)
                            combatViewModel.executeTurn(player: combatScene.character, enemyA: combatScene.enemyA, enemyB: combatScene.enemyB, enemyC: combatScene.enemyC, attackUsed: .focusPunch, sceneManager: viewModel) { actualMana in
                                //verifyMana(actualMana: actualMana)
                            }
                            combatScene.showEveryoneHealth()
                            updateBars()
                        })
                        //                        CombatButtonSUI(mainText: "Duplicate", shortcutText: "S", isEnabled: true, action: { ficaAquiPora = true;
                        CombatButtonSUI(mainText: "Eruption", shortcutText: "J", isEnabled: $eruptionHasEnoughMana, action:
                        {
                            focus = true
                            lockButtons()
                            AudioPlayerImpl.shared.play(effect: Audio.EffectFiles.button)
                            combatViewModel.executeTurn(player: combatScene.character, enemyA: combatScene.enemyA, enemyB: combatScene.enemyB, enemyC: combatScene.enemyC, attackUsed: .eruption, sceneManager: viewModel) { actualMana in
                                //verifyMana(actualMana: actualMana)
                            }
                            combatScene.showEveryoneHealth()
                            updateBars()
                        })
                        //                        CombatButtonSUI(mainText: "Weaken", shortcutText: "F", isEnabled: false, action: { ficaAquiPora = true; viewModel.combatScene.viewModel.playButtonSFX() })
                        CombatButtonSUI(mainText: "Back", shortcutText: "K", isEnabled: $buttonEnabled, action: {
                            focus = true
                            AudioPlayerImpl.shared.play(effect: Audio.EffectFiles.button)
                            combatViewModel.changeButtonSetTo(.mainSelection)
                        })
                    } else {
                        CombatButtonSUI(mainText: "Attack", shortcutText: "H", isEnabled: $buttonEnabled, action:
                        {
                            AudioPlayerImpl.shared.play(effect: Audio.EffectFiles.button)
                            combatViewModel.changeButtonSetTo(.attackSelection)
                            
                        })
                        CombatButtonSUI(mainText: "Heal", shortcutText: "J", isEnabled: $healHasEnoughMana, action:
                        {
                            focus = true
                            lockButtons()
                            AudioPlayerImpl.shared.play(effect: Audio.EffectFiles.button)
                            combatViewModel.executeTurn(player: combatScene.character, enemyA: combatScene.enemyA, enemyB: combatScene.enemyB, enemyC: combatScene.enemyC, attackUsed: .healing, sceneManager: viewModel) { actualMana in
                                //verifyMana(actualMana: actualMana)
                            }
                            
                            combatScene.showEveryoneHealth()
                            updateBars()
                        })
//                        CombatButtonSUI(mainText: "Flee", shortcutText: "K", isEnabled: $buttonEnabled, action: {
//                            focus = true
//                            viewModel.combatScene.viewModel.playButtonSFX()
//                            viewModel.changeScene(scene: .GameScene)
//
//                        })
                    }
                }
                .focused($focus)
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).maxY - (geometry.size.height / 7))
                .onAppear {
                    combatViewModel.sceneManagerViewModel = viewModel
                    combatScene.showEveryoneHealth()
                    updateBars()
                }
                .onChange(of: focus) { _ in
                    focus = true
                }
            }
         
        }
    }

    func updateBars() {
        let character = combatScene.character
        
        self.healthPercentage = Float(character.currentHealth) / Float(character.maxHealth)
        if self.healthPercentage < 0 { self.healthPercentage = 0 }
        if self.healthPercentage > 1 { self.healthPercentage = 1 }
        
        self.manaPercentage = Float(character.currentMana) / Float(character.maxMana)
        if self.manaPercentage < 0 { self.manaPercentage = 0 }
        if self.manaPercentage > 1 { self.manaPercentage = 1 }
    }
    
    func verifyMana(actualMana: Int) {
        if actualMana < 5 {
            healHasEnoughMana = false
            eruptionHasEnoughMana = false
            return
        }
        if actualMana < 6 {
            eruptionHasEnoughMana = false
            healHasEnoughMana = true
            return
        }
        eruptionHasEnoughMana = true
        healHasEnoughMana = true
    }
    
    func lockButtons() {
        let delay = 2
        
        self.buttonEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
            self.buttonEnabled = true
        }
    }
}

//struct CombatSceneView_Previews: PreviewProvider {
//    @StateObject static var vM = SceneManagerViewModel()
//
//    static var previews: some View {
//        CombatSceneView(gameScene: GameScene(size: CGSize(width: 1024, height: 768)))
//            .environmentObject(vM)
//    }
//}
