//
//  Card.swift
//  ConcentrationGame
//
//  Created by Anmol Jandaur on 8/21/19.
//  Copyright © 2019 Anmol Jandaur. All rights reserved.
//

import Foundation
//Struct initializes all of its vars

struct Card: Hashable
{
    
    var hashValue: Int { return identifier}
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    
    var isFaceUp = false     { didSet { if isFaceUp { isSeen = true } } }
    var isSeen = false
    var isMatched = false
    private var identifier: Int
    
    /// Variable is part of static function, you can only access for card type
    private static var identifierFactory = 0
    
    //You ask the card type for the static f(x)
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}

//Two majors differences between struct and class:
//Struct has NO inheritance
//Structs are value types, classes are reference types

