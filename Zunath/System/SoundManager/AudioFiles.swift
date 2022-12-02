//
//  AudioFiles.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 11/11/22.
//

import Foundation

struct Audio {
    struct MusicFiles {
        static let menuPrincipal = Music(filename: "MenuPrincipal", type: "mp3")
        static let exploracao = Music(filename: "Exploracao", type: "mp3")
        static let exploracao2 = Music(filename: "Exploracao2", type: "mp3")
        static let combate = Music(filename: "Combate", type: "mp3")
    }
    
    struct EffectFiles {
        static let button = Effect(filename: "button", type: "wav")
        static let ouchie = Effect(filename: "ouchie", type: "wav")
        static let capitalismo = Effect(filename: "capitalismo", type: "wav")
        static let mori = Effect(filename: "mori", type: "wav")
    }
}
