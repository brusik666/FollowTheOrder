//
//  FinalViewController.swift
//  FollowTheOrder
//
//  Created by Brusik on 25.10.2022.
//

import UIKit
import SpriteKit

class FinalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func getWishFromFortune(completion: @escaping (Result<String, Error>) -> Void) {

        let url = URL(string: "http://yerkee.com/api/fortune")!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let wish = try JSONDecoder().decode(String.self, from: data)
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

}
