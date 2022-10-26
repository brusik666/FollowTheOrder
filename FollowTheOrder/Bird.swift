//
//  Bird.swift
//  FollowTheOrder
//
//  Created by Brusik on 25.10.2022.
//

import Foundation
import SpriteKit

class Bird: SKSpriteNode {
    
    func shakeAnimation() {
        let scaleUpAction = SKAction.scale(to: 1.25, duration: 0.1)
        let scaleDownAction = SKAction.scale(to: 1, duration: 0.1)
        let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction, scaleUpAction, scaleDownAction])
        self.run(scaleActionSequence)
    }
    
    func successAnimation() {

        let successAction = SKAction.colorize(with: .green, colorBlendFactor: 0.5, duration: 0.2)
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 0.5)
        let actionGroup = SKAction.group([successAction, rotateAction])
        self.run(actionGroup)
    }
    
    func failAnimation() {
        
        let failAction = SKAction.colorize(with: .red, colorBlendFactor: 0.5, duration: 0.2)
        let upSizeAction = SKAction.scale(to: 2, duration: 1)
        let actionGrup = SKAction.group([failAction, upSizeAction])
        self.run(actionGrup)
    }
}


