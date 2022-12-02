//
//  EnemyMovevement.swift
//  Macro
//
//  Created by Arthur Martins Saraiva on 21/09/22.
//

import Foundation
import SpriteKit

extension Enemy {
    
    private func returnAngle(angle: Double) -> Double {
        return angle * (.pi/180)
    }
    
//    func moveToPoint(therePoint: CGPoint, timeWalking: Double) {
//        var directionTaken: AnimationDirection!
//
//        if therePoint.y != self.lastPos.y {
//            therePoint.y >= self.lastPos.y || therePoint.y == self.position.y ? (directionTaken = .up) : (directionTaken = .down)
//        }
//        if therePoint.x != self.position.x || (therePoint.x == self.position.x && directionTaken != .up && directionTaken != .down) { directionTaken = .side }
//
//        if therePoint.y > self.lastPos.y { directionTaken = .up } else { directionTaken = .down }
//        if therePoint.x != self.lastPos.x && therePoint.y != self.lastPos.y { directionTaken = .side }
//
//        self.lastPos = therePoint
//
//        self.toMove.append(.run {
//            self.playAnimation(state: .walk, direction: directionTaken)
//        })
//        self.toMove.append(.move(to: therePoint, duration: timeWalking))
//        self.toMove.append(.run {
//            self.playAnimation(state: .idle, direction: directionTaken)
//        })
//        self.toMove.append(.wait(forDuration: 1.5))
//    }
    
    func moveToX(xPos: CGFloat, timeWalking: Double) {
        var directionTaken: AnimationDirection!
        var scale: CGFloat
        
        if self.lastPos.x != xPos { directionTaken = .side } else { return }
        if self.lastPos.x > xPos { scale = -self.worldSprite.xScale } else { scale = abs(self.worldSprite.xScale) }
        
        self.lastPos.x = xPos
        
        self.toMove.append(.run {
            self.worldSprite.xScale = scale
            self.playAnimation(state: .walk, direction: directionTaken)
        })
        self.toMove.append(.moveTo(x: xPos, duration: timeWalking))
        self.toMove.append(.run {
            self.playAnimation(state: .idle, direction: directionTaken)
        })
        self.toMove.append(.wait(forDuration: 1.5))
    }
    
    func moveToY(yPos: CGFloat, timeWalking: Double) {
        var directionTaken: AnimationDirection!
        
        if self.lastPos.y > yPos { directionTaken = .down }
        if self.lastPos.y < yPos { directionTaken = .up }
        if self.lastPos.y == yPos { return }
        
        self.lastPos.y = yPos
        
        self.toMove.append(.run {
            self.playAnimation(state: .walk, direction: directionTaken)
        })
        self.toMove.append(.moveTo(y: yPos, duration: timeWalking))
        self.toMove.append(.run {
            self.playAnimation(state: .idle, direction: directionTaken)
        })
        self.toMove.append(.wait(forDuration: 1.5))
    }
    
    func lookToAngle(angleToSee: Double, timeTurning: Double) {
        self.toMove.append(.run({
            var lookDir: AnimationDirection
            
            switch abs(angleToSee) {
            case 46...135:
                lookDir = .side
                self.worldSprite.xScale = -(self.worldSprite.xScale)
            case 0...45,
                 316...360:
                lookDir = .up
            case 136...225:
                lookDir = .down
            case 226...315:
                lookDir = .side
                self.worldSprite.xScale = (self.worldSprite.xScale)
            default:
                lookDir = .down
            }
            
            self.playAnimation(state: .idle, direction: lookDir)
            self.childNode(withName: "vision")?.run(.rotate(toAngle: self.returnAngle(angle: angleToSee), duration: timeTurning))
            self.toMove.append(.wait(forDuration: 1))
        }))
        self.toMove.append(.wait(forDuration: 0.75))
    }
    
    func overrideIdleAnimation(direction: AnimationDirection) {
        self.toMove.append(.run {
            self.playAnimation(state: .idle, direction: direction)
        })
    }
    
    func lookBack(timeTurning: Double) {
        self.toMove.append(.run({
            self.childNode(withName: "vision")?.run(.rotate(toAngle: 3.14 - self.returnAngle(angle: self.visionAngle), duration: timeTurning))
            self.toMove.append(.wait(forDuration: 1))
        }))
        self.toMove.append(.wait(forDuration: 0.75))
    }
    
    func startVision(timeTurning: Double) {
        self.toMove.append(.run({
            self.childNode(withName: "vision")?.run(.rotate(toAngle: -self.returnAngle(angle: self.visionAngle), duration: timeTurning))
            self.toMove.append(.wait(forDuration: 1))
        }))
        self.toMove.append(.wait(forDuration: 0.75))
    }
    
}
