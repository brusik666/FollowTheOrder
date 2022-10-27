//
//  GameScene.swift
//  FollowTheOrder
//
//  Created by Brusik on 25.10.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var birdsAdded = [Bird]()
    var game = Game()
    private var background = SKSpriteNode(imageNamed: "back")
    private var startGameButton: SKLabelNode = {
        let startGameNode = SKLabelNode(text: "START GAME")
        startGameNode.position = CGPoint(x: 0, y: 0)
        startGameNode.isUserInteractionEnabled = false
        startGameNode.zPosition = 2
        startGameNode.fontColor = SKColor.black
        startGameNode.name = "startgame"
        return startGameNode
    }()
    
    lazy private var scoreLabel: SKLabelNode = {
        let scoreLabel = SKLabelNode(text: "Current Score: \(self.game.playerScore)" )
        scoreLabel.position = CGPoint(x: 0, y: frame.maxY - 90)
        scoreLabel.fontColor = SKColor.black
        scoreLabel.fontName = "ArialBoldItalic"
        scoreLabel.zPosition = 2
        return scoreLabel
    }()
    
    lazy private var bestScoreLabel: SKLabelNode = {
        let scoreLabel = SKLabelNode(text: "Best Score: \(self.game.bestPlayerScore)" )
        scoreLabel.position = CGPoint(x: 0, y: frame.maxY - 60)
        scoreLabel.fontColor = SKColor.black
        scoreLabel.fontName = "ArialBoldItalic"
        scoreLabel.zPosition = 2
        return scoreLabel
    }()
    
    override func didMove(to view: SKView) {

        background.size.height = frame.height
        background.size.width = frame.width
        background.zPosition = 1
        background.blendMode = .alpha
        addChild(background)
        background.addChild(startGameButton)
        
    }
    
    
    func newRound() {
        game.birdsNumbers = Array(1...game.birdsCount)
        createBirds()
    }
    
    func updateCurrentScoreLabel() {
        self.scoreLabel.text = "Current Score: \(self.game.playerScore)"
    }
    
    func updateBestScoreLabel() {
        self.bestScoreLabel.text = "Best Score: \(self.game.bestPlayerScore)"
    }
    
    func random() -> (Int, Int) {
        let width = UIScreen.main.bounds.width/2 - 35
        let height = UIScreen.main.bounds.height/2 - 120
        let xPosition = Int.random(in: Int(-width)...Int(width))
        let yPosition = Int.random(in: Int(-height)...Int(height))
        return (xPosition, yPosition)
    }

    func createBirds() {
        var birdsNumbersArray = Array(1...game.birdsCount)
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run { [unowned self] in
            let bird = Bird(imageNamed: "bird")
            bird.name = String(birdsNumbersArray.removeFirst())
            bird.size.height = 70
            bird.size.width = 70
            bird.zPosition = 2
            
            background.addChild(bird)
            bird.shakeAnimation()
            
            var intersects  = true
            while intersects {
                bird.position = CGPoint(x: random().0, y: random().1)
                intersects = false
                for cBird in birdsAdded {
                    if bird.intersects(cBird) {
                        intersects = true
                        break
                    }
                }
            }
            birdsAdded.append(bird)
            
        }
        let sequence = SKAction.sequence([block, wait])
        let loop = SKAction.repeat(sequence, count: game.birdsCount)
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
                self.addChild(bestScoreLabel)
            }
            
            if let birdNode = touchedNode as? Bird {
                if birdNode.name == String(game.birdsNumbers.removeFirst()) {
                    birdNode.successAnimation()
                    birdNode.isUserInteractionEnabled = true
                    guard game.birdsNumbers.isEmpty else { break }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[unowned self] in
                        game.playerScore += 1
                        if game.playerScore > game.bestPlayerScore {
                            game.bestPlayerScore = game.playerScore
                            game.saveBestScore()
                        }
                        updateCurrentScoreLabel()
                        updateBestScoreLabel()
                        background.removeAllChildren()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "win"), object: nil)
                    }
                } else {
                    birdNode.failAnimation()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[unowned self] in
                        self.game.playerScore = 0
                        updateCurrentScoreLabel()
                        self.background.removeAllChildren()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "loose"), object: nil)
                        
                    }
                }
            }
        }
    }
    
    
}
