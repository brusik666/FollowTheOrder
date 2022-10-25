//
//  GameScene.swift
//  FollowTheOrder
//
//  Created by Brusik on 25.10.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
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
    
    
    override func didMove(to view: SKView) {

        background.size.height = frame.height
        background.size.width = frame.width
        background.zPosition = 1
        addChild(background)
        background.addChild(startGameButton)
        
    }
    
    
    func newRound() {
        createBirds(playerScore: playerScore)
    }
    
    func random() -> (Int, Int) {
        let width = UIScreen.main.bounds.width/2 - 50
        let height = UIScreen.main.bounds.height/2 - 50
        let xPosition = Int.random(in: Int(-width)...Int(width))
        let yPosition = Int.random(in: Int(-height)...Int(height))
        return (xPosition, yPosition)
    }
    private func createBirds(playerScore: Int) {
        for birdNumber in 1...(5 + playerScore) {
            let bird = SKSpriteNode(imageNamed: "bird")
            bird.name = String(birdNumber)
            bird.size.height = 100
            bird.size.width = 100
            bird.zPosition = 2
            bird.position = CGPoint(x: random().0, y: random().1)
            addChild(bird)
            let delayAction = SKAction.wait(forDuration: 1)
        }
    }
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            print(touchedNode.name)
            print(touchedNode.zPosition)
            if touchedNode.name == "startgame" {
                touchedNode.removeFromParent()
                self.newRound()
            }
        }
    }
}
