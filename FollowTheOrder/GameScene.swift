//
//  GameScene.swift
//  FollowTheOrder
//
//  Created by Brusik on 25.10.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var background = SKSpriteNode(imageNamed: "back")
    private let bird = SKSpriteNode(imageNamed: "bird")
    private lazy var startGameButton: SKLabelNode = {
        let startGameNode = SKLabelNode(text: "START GAME")
        startGameNode.position = CGPoint(x: 0, y: 0)
        startGameNode.isUserInteractionEnabled = false
        startGameNode.zPosition = 2
        startGameNode.fontColor = SKColor.black
        startGameNode.name = "startgame"
        return startGameNode
    }()
    private var playerScore = 0
    var birdsCenteredPositions = [(Int,Int)]()
    var birdsCount: Int {
        return 5 + playerScore
    }
    
    override func didMove(to view: SKView) {

        background.size.height = frame.height
        background.size.width = frame.width
        background.zPosition = 1
        background.blendMode = .alpha
        addChild(background)
        background.addChild(startGameButton)
        
    }
    
    
    func newRound() {
        createBirds(birdNumber: 1)
    }
    
    func random() -> (Int, Int) {
        let width = UIScreen.main.bounds.width/2 - 35
        let height = UIScreen.main.bounds.height/2 - 35
        let xPosition = Int.random(in: Int(-width)...Int(width))
        let yPosition = Int.random(in: Int(-height)...Int(height))
        return (xPosition, yPosition)
    }

    func createBirds(birdNumber: Int) {
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run { [unowned self] in
            let bird = Bird(imageNamed: "bird")
            bird.name = String(birdNumber)
            bird.size.height = 70
            bird.size.width = 70
            bird.zPosition = 2
            bird.position = CGPoint(x: random().0, y: random().1)
            addChild(bird)
            bird.shakeAnimation()
        }
        let sequence = SKAction.sequence([block, wait])
        let loop = SKAction.repeat(sequence, count: birdsCount)
        run(loop)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "startgame" {
                touchedNode.removeFromParent()
                self.newRound()
            }
            
            if let birdNode = touchedNode as? Bird {
                birdNode.successAnimation()
            }
        }
    }
    
    func isOrderOfPickingBirdCorrect() {
        
    }
}
