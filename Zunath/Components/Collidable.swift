//
//  Collidable.swift
//  Macro
//
//  Created by Paulo César on 14/09/22.
//

import Foundation
import SpriteKit

protocol Collidable {
    var hitBox: SKPhysicsBody { get set }
}
