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
    private lazy var startGameButton: SKLabelNode = {
        let startGameNode = SKLabelNode(text: "START GAME")
        startGameNode.position = CGPoint(x: 0, y: 0)
        startGameNode.isUserInteractionEnabled = false
        startGameNode.zPosition = 2
        startGameNode.fontColor = SKColor.black
        startGameNode.name = "startgame"
        return startGameNode
    }()
    
    lazy private var scoreLabel: SKLabelNode = {
        let scoreLabel = SKLabelNode(text: "YOUR SCORE: \(self.playerScore)" )
        scoreLabel.position = CGPoint(x: frame.minX + 32, y: frame.maxY - 60)
        scoreLabel.fontColor = SKColor.black
        scoreLabel.fontName = "ArialBoldItalic"
        scoreLabel.zPosition = 2
        return scoreLabel
    }()
    
    lazy private var bestScoreLabel: SKLabelNode = {
        let scoreLabel = SKLabelNode(text: "BEST SCORE: \(self.playerScore)" )
        scoreLabel.position = CGPoint(x: frame.minX + 32, y: frame.maxY - 60)
        scoreLabel.fontColor = SKColor.black
        scoreLabel.fontName = "ArialBoldItalic"
        scoreLabel.zPosition = 2
        return scoreLabel
    }()
    
    private var playerScore = 0 {
        didSet {
            scoreLabel.text = "YOUR SCORE: \(self.playerScore)"
        }
    }
    private var bestScore: Int {
        return 0
    }
    var birdsCenteredPositions = [(Int,Int)]()
    var birdsNumbers = [Int]()
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
        birdsNumbers = Array(1...self.birdsCount)
        createBirds()
        
    }
    
    func random() -> (Int, Int) {
        let width = UIScreen.main.bounds.width/2 - 35
        let height = UIScreen.main.bounds.height/2 - 100
        let xPosition = Int.random(in: Int(-width)...Int(width))
        let yPosition = Int.random(in: Int(-height)...Int(height))
        return (xPosition, yPosition)
    }

    func createBirds() {
        var birdsNumbersArray = Array(1...birdsCount)
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run { [unowned self] in
            let bird = Bird(imageNamed: "bird")
            bird.name = String(birdsNumbersArray.removeFirst())
            bird.size.height = 70
            bird.size.width = 70
            bird.zPosition = 2
            bird.position = CGPoint(x: random().0, y: random().1)
            background.addChild(bird)
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
                self.addChild(scoreLabel)
            }
            
            if let birdNode = touchedNode as? Bird {
                if birdNode.name == String(birdsNumbers.removeFirst()) {
                    birdNode.successAnimation()
                    birdNode.isUserInteractionEnabled = true
                    guard birdsNumbers.isEmpty else { break }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[unowned self] in
                        playerScore += 1
                        background.removeAllChildren()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "win"), object: nil)
                    }
                } else {
                    birdNode.failAnimation()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[unowned self] in
                        self.playerScore = 0
                        self.background.removeAllChildren()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "loose"), object: nil)
                        
                    }
                }
            }
        }
    }
    
    
}
