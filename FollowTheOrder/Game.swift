//
//  Game.swift
//  FollowTheOrder
//
//  Created by Brusik on 26.10.2022.
//

import Foundation

struct Game {
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let bestGameScoreUrl = Game.documentsDirectory.appendingPathComponent("bestGameScore").appendingPathExtension("plist")
    
    var playerScore = 0
    lazy var bestPlayerScore: Int = {
        if let savedBestScore = loadBestScore() {
            return savedBestScore
        } else {
            return 0
        }
    }()
    var birdsNumbers = [Int]()
    var birdsCount: Int {
        return 5 + playerScore
    }
    var updatePlayerScoreLabel: (() -> Void)? = {}
    var updateBestPlayerScoreLabel: () -> Void = {}
    
    
    
    mutating func saveBestScore() {
        let propertyListEncoder = PropertyListEncoder()
        do {
            let codedData = try propertyListEncoder.encode([bestPlayerScore])
            try codedData.write(to: Game.bestGameScoreUrl, options: .noFileProtection)
        } catch {
            print(String(describing: error))
        }
    }
    
    func loadBestScore() -> Int? {
        let propertyListDecoder = PropertyListDecoder()
        guard let codedScoreData = try? Data(contentsOf: Game.bestGameScoreUrl),
              let bestScore = try? propertyListDecoder.decode([Int].self, from: codedScoreData) else { return nil }
        
        return bestScore.first!
    }
    
}


