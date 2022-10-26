//
//  Game.swift
//  FollowTheOrder
//
//  Created by Brusik on 26.10.2022.
//

import Foundation

struct Game {
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let bestGameScoreUrl = documentsDirectory.appendingPathComponent("bestGameScore").appendingPathExtension("plist")
    
    var playerScore = 0 {
        didSet {
            updatePlayerScoreLabel()
        }
    }
    var updatePlayerScoreLabel: () -> Void = {}
    var updateBestPlayerScoreLabel: () -> Void = {}
    
    lazy var bestPlayerScore: Int = {
        if let savedBestScore = loadBestScore() {
            return savedBestScore
        } else {
            return 0
        }
    }()
    
    func newRound() {
        
    }
    
    func createBirds() {
        
    }
    
    mutating func saveBestScore() {
        let propertyListEncoder = PropertyListEncoder()
        let codedData = try? propertyListEncoder.encode(bestPlayerScore)
        try? codedData?.write(to: bestGameScoreUrl, options: .noFileProtection)
    }
    
    func loadBestScore() -> Int? {
        let propertyListDecoder = PropertyListDecoder()
        guard let codedScoreData = try? Data(contentsOf: bestGameScoreUrl) else { return nil }
        let bestScore = try? propertyListDecoder.decode(Int.self , from: codedScoreData)
        return bestScore
    }
    
}


