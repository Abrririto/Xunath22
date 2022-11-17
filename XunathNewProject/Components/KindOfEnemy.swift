//
//  TypeOfEnemy.swift
//  Macro
//
//  Created by Arthur Martins Saraiva on 09/10/22.
//

import Foundation
import SpriteKit

internal enum EnemyTypes {
    case commomEnemy
    case blindMage
    case knight
    case cleric
    
    var life: Int {
        switch self {
        case .commomEnemy: return 50
        case .blindMage: return 30
        case .knight: return 80
        case .cleric: return 25
        }
    }
}

protocol KindOfEnemy {
    var typeOfEnemy: EnemyTypes { get set }
    var takenDamage: Int { get set }
    var percentualLife: Int { get set }
    func valueOfLife() -> Int
}

extension KindOfEnemy {
    func valueOfLife() -> Int {
        let life = self.typeOfEnemy.life
        let actualLife = life - takenDamage
        return (life / actualLife * 100)
    }
}
