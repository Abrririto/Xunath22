//
//  CombatButtonSUI.swift
//  Macro
//
//  Created by Paulo César on 20/10/22.
//

import SwiftUI

enum CombatButtonState {
    case mainSelection
    case attackSelection
}

struct CombatButtonSUI: View {
    var mainText: String
    var shortcutText: String
    @Binding var isEnabled: Bool
    var action: () -> ()
        
    @ViewBuilder
    var body: some View {
        Button(action: self.action, label: {
            ZStack {
                GeometryReader { geometry in
                    Text(mainText)
                        .font(.custom("Alagard", size: geometry.size.width * 0.175))
                        .foregroundColor(Color(red: 0.03, green: 0.11, blue: 0.16))
                        .shadow(color: .white, radius: 5)
                        .minimumScaleFactor(0.01)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                    
                    Text(shortcutText).font(.custom("Alagard", size: geometry.size.width * 0.15)).foregroundColor(Color(red: 0.21, green: 0.28, blue: 0.38))
                        .shadow(color: .white, radius: 2.5)
                        .zIndex(-1)
                        .minimumScaleFactor(0.01)
                        .position(x: geometry.frame(in: .local).maxX - (geometry.size.width / 12), y: geometry.frame(in: .local).maxY - (geometry.size.height / 5))
                }
                
                (isEnabled ? Image("btn_enabled") : Image("btn_disabled"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
                    .zIndex(-2)
            }
        })
        .keyboardShortcut(KeyEquivalent(Character(shortcutText.lowercased())), modifiers: [])
        .transition(.identity)
        .buttonStyle(PlainButtonStyle())
        .scaledToFit()
        .disabled(!isEnabled)
    }
}

//struct CombatButtonSUI_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        HStack {
//            CombatButtonSUI(mainText: "Attack", shortcutText: "A", isEnabled: true, action: {})
//            CombatButtonSUI(mainText: "Heal", shortcutText: "S", isEnabled: true, action: {})
//            CombatButtonSUI(mainText: "Flee", shortcutText: "D", isEnabled: true, action: {})
//        }
//        .frame(width: 1024, height: 768)
//        HStack {
//            CombatButtonSUI(mainText: "Focus Punch", shortcutText: "A", isEnabled: true, action: {})
//            CombatButtonSUI(mainText: "Duplicate", shortcutText: "S", isEnabled: true, action: {})
//            CombatButtonSUI(mainText: "Eruption", shortcutText: "D", isEnabled: false, action: {})
//            CombatButtonSUI(mainText: "Weaken", shortcutText: "F", isEnabled: false, action: {})
//            CombatButtonSUI(mainText: "Back", shortcutText: "G", isEnabled: true, action: {})
//        }
//        .frame(width: 1024, height: 768)
//    }
//}
