//
//  PlayerControllable.swift
//  Macro
//
//  Created by Paulo César on 13/09/22.
//  Modified by Arthur Martins Saraiva on 05/11/22.
//  The logic used to move and animate: A value is added to an array and this value makes the control for where the player is going for. Its animation is correspondent called based on this value.

import Foundation
import SpriteKit

protocol PlayerControllable {
    var movementController: Set<Int> { get set }
    var maxVelocity: CGFloat { get }
    mutating func startMoving(_ hex: UInt16)
    mutating func stopMoving(_ hex: UInt16)
    mutating func clearMovementBuffer()
}

extension PlayerControllable where Self: MainCharacter {
    /// Controls when the player press an moving key. It adds a value to var "movementController" and calls its correspondent animation.
    /// - Parameter hex: A hex of the key that was pressed.
    mutating func startMoving(_ hex: UInt16) {
        switch hex {
        case WalkKeybinds.UP.rawValue, WalkKeybinds.ALTERNATIVEUP.rawValue:
            movementController.insert(1)
        case WalkKeybinds.DOWN.rawValue, WalkKeybinds.ALTERNATIVEDOWN.rawValue:
            movementController.insert(2)
        case WalkKeybinds.LEFT.rawValue, WalkKeybinds.ALTERNATIVELEFT.rawValue:
            movementController.insert(3)
        case WalkKeybinds.RIGHT.rawValue, WalkKeybinds.ALTERNATIVERIGHT.rawValue:
            movementController.insert(4)
        default: return
        }
        self.currentDirection = isWalkingAnimation()
    }
    
    /// Logic to control the movement and set the current animation.
    mutating func updatePosition() {
        if self.movementController.contains(1) {
            controlSpeed(dYmovement: 1, dXMovement: nil)
            self.currentDirection = .up
        }
        if self.movementController.contains(2) {
            controlSpeed(dYmovement: -1, dXMovement: nil)
            self.currentDirection = .down
        }
        if self.movementController.contains(3) {
            controlSpeed(dYmovement: nil, dXMovement: -1)
            self.currentDirection = .side
            self.xScale = -abs(self.xScale)                            // Asset walking sideways (inverted to be right side)
        }
        if self.movementController.contains(4) {
            controlSpeed(dYmovement: nil, dXMovement: 1)
            self.currentDirection = .side
            self.xScale = abs(self.xScale)                             // Asset walking sideways (left)
        }
    }
    
    /// Controls when the player release an moving key. It removes a value of var "movementController" and calls isStoppedAnimation if the player is not pressing any move key.
    /// - Parameter hex: A hex of the key that was released.
    mutating func stopMoving(_ hex: UInt16) {
        switch hex {
        case WalkKeybinds.UP.rawValue, WalkKeybinds.ALTERNATIVEUP.rawValue:
            movementController.remove(1)
        case WalkKeybinds.DOWN.rawValue, WalkKeybinds.ALTERNATIVEDOWN.rawValue:
            movementController.remove(2)
        case WalkKeybinds.LEFT.rawValue, WalkKeybinds.ALTERNATIVELEFT.rawValue:
            movementController.remove(3)
        case WalkKeybinds.RIGHT.rawValue, WalkKeybinds.ALTERNATIVERIGHT.rawValue:
            movementController.remove(4)
        default: break
        }
        isStoppedAnimation()
    }
    
    /// Equation for speed control.
    /// - Parameters:
    ///   - dYmovement: Value that multiply maxVelocity to move on vertical position.
    ///   - dXMovement: Value that multiply maxVelocity to move on horizontal position.
    func controlSpeed(dYmovement: Double?, dXMovement: Double?) {
        self.position.x += self.maxVelocity * (dXMovement ?? 0)
        self.position.y += self.maxVelocity * (dYmovement ?? 0)
    }
    
    /// Clear buffer when the player starts or finish the combat.
    mutating func clearMovementBuffer() {
        movementController.removeAll()
        self.playAnimation(state: .idle, direction: .down)
    }
}
