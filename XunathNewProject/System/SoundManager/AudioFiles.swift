//
//  AudioFiles.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 11/11/22.
//

import Foundation

struct Audio {
    struct MusicFiles {
        static let menuPrincipal = Music(filename: "menuPrincipal", type: "mp3")
        static let button = Music(filename: "button", type: "wav")
    }
    
    struct EffectFiles {
        static let button = Effect(filename: "button", type: "wav")
        static let ouchie = Effect(filename: "ouchie", type: "wav")
        static let capitalismo = Effect(filename: "capitalismo", type: "wav")
        static let mori = Effect(filename: "mori", type: "wav")
    }
}
