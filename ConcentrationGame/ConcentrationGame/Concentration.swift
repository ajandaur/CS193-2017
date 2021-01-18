//
//  Concentration.swift
//  ConcentrationGame
//
//  Created by Anmol Jandaur on 8/21/19.
//  Copyright © 2019 Anmol Jandaur. All rights reserved.
//

import Foundation

//Structs only copy the bits when it is mutated (copy on write semantics), it is a value type
// Classes live in the heap and pointers are passed around
struct Concentration {
    
    private(set) var cards = [Card]()
    
    ///Want to keep track of when there is only one card face up
    private var indexOfOneAndOnlyFaceUpCard: Int?
    
    var score = 0
    var flipCount = 0
    
    static var matchPoints = 20
    static var faceUpPenalty = 10
    
    mutating func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += Concentration.matchPoints
                } else {
                    if cards[index].isSeen {
                        score -= Concentration.faceUpPenalty
                    }
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                //either no card or two cards are face up
                for flipdownIndex in cards.indices {
                    cards[flipdownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        flipCount += 1
    }
    
    init(numberOfPairsOfCards: Int) {
        var unShuffledCards: [Card] = []
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            unShuffledCards += [card,card]
        }
        // Shuffle the cards
        while !unShuffledCards.isEmpty {
            let randomIndex = unShuffledCards.count.arc4Random
            let card = unShuffledCards.remove(at: randomIndex)
            cards.append(card)
        }
        
    }
}
