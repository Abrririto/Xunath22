//
//  MainMenuView.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 24/10/22.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var viewModel: SceneManagerViewModel
    @State var disableContinueButton = false
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
//                Spacer()
                Image("ZunathHomeScreen")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .padding(.bottom, -50)
                    
                MainMenuButton(title: "Continue", color: Color(red: 60/255, green: 61/255, blue: 104/255, opacity: 1)) {
                    viewModel.loadGame()
                }.disabled(disableContinueButton) /*.disabled(disableContinueButton)*/
                
                MainMenuButton(title: "New Game", color: Color(.sRGB, red: 54/255, green: 79/255, blue: 67/255, opacity: 1)) {
                    viewModel.newGame()
                }
                
                MainMenuButton(title: "Exit", color: Color(.sRGB, red: 71/255, green: 41/255, blue: 41/255, opacity: 1)) {
                    NSApplication.shared.terminate(nil)
                }
                .padding(.top, 50)
                Spacer()
                    .frame(width: 1, height: 100)
            }
        }
        .onAppear {
            AudioPlayerImpl.shared.playInLoop(music: Audio.MusicFiles.menuPrincipal)
            disableContinueButton = SaveManager.shared.checkIfSaveExists()
        }
    }
}

enum MainMenuButtonEnum {
    case newGame
    case continueGame
    case exitGame
    
    var description: String {
        switch self {
            case .newGame:
                return "New Game"
            case .continueGame:
                return "Continue"
            case .exitGame:
                return "Exit"
        }
    }
}

struct MainMenuButton: View {
    var title: String
    var color: Color
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Text(title)
                    .frame(width: 400, height: 75)
                    .font(.custom("Alagard", size: 28))
                    .background(color)
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 5, x: 3, y: -3)
            }
            
                
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
