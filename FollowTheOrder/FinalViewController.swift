//
//  FinalViewController.swift
//  FollowTheOrder
//
//  Created by Brusik on 25.10.2022.
//

import UIKit
import SpriteKit

class FinalViewController: UIViewController {

    @IBOutlet weak var finalWordsLabel: UILabel!
    @IBOutlet weak var continueGameButton: UIButton!
    
    private var victory: Bool {
        let gameViewController = navigationController?.viewControllers.first as! GameViewController
        return gameViewController.victory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setContinueGameButtonText()
        getWishFromFortune { result in
            switch result {
            case .success(let wish):
                print(wish)
            case .failure(let erro):
                print(erro)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    private func getWishFromFortune(completion: @escaping (Result<FortuneResponse, Error>) -> Void) {

        let url = URL(string: "http://yerkee.com/api/fortune")!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let wish = try JSONDecoder().decode(FortuneResponse.self, from: data)
                    completion(.success(wish))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func setContinueGameButtonText() {
        switch victory {
        case true:
            continueGameButton.titleLabel?.text = "Continue game"
            getWishFromFortune { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.finalWordsLabel.text = response.fortune
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self.finalWordsLabel.text = "You're doing fine!"
                    }
                }
            }
        default:
            continueGameButton.titleLabel?.text = "Start new Game"
            finalWordsLabel.text = "OOOOOOOPS!"
        }
    }
    @IBAction func continueGameButtonTapped(_ sender: Any) {
        
    }
    
}
