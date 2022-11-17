//
//  MainCharModel.swift
//  Xunath
//
//  Created by Gabriel do Prado Moreira on 27/10/22.
//

import Foundation

class MainCharModel: Codable {
    var life: Int
    var attack: Int
    var defense: Int
    var agility: Int
    var mana: Int
    var level: Int
    var position: CGPoint
    
    init(life: Int, attack: Int, defense: Int, agility: Int, mana: Int, level: Int = 1, position: CGPoint = CGPoint(x: -240, y: 80)) {
        self.life = life
        self.attack = attack
        self.defense = defense
        self.agility = agility
        self.mana = mana
        self.level = level
        self.position = position
        
    }
}
