//
//  GameViewController.swift
//  FollowTheOrder
//
//  Created by Brusik on 25.10.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var victory: Bool = false
    var scene: GameScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleVictoryInGameRound), name: Notification.Name(rawValue: "win"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLostInGameRound), name: Notification.Name(rawValue: "loose"), object: nil)
        
        if let view = self.view as! SKView? {
            if let scene = GameScene(fileNamed: "GameScene") {
                self.scene = scene
                scene.scaleMode = .resizeFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func handleVictoryInGameRound() {
        self.victory = true
        performSegue(withIdentifier: "finalSegue", sender: nil)
    }
    
    @objc func handleLostInGameRound() {
        self.victory = false
        performSegue(withIdentifier: "finalSegue", sender: nil)
    }
    
    @IBAction func unwindToGameViewController(unwindSegue : UIStoryboardSegue) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[unowned self] in
            self.scene.newRound()
        }
    }
}
