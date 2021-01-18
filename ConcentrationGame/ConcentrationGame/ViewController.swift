//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Anmol Jandaur on 8/21/19.
//  Copyright © 2019 Anmol Jandaur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //lazy = the var doesn't initialize until it is used
    var game: Concentration!
    
    ///Create a type to describe the stuff in each theme
    typealias themeStuff = (emoji: [String], backgroundColor: UIColor, cardColor: UIColor)
    
    /// holds all the emojis for the card
    private let themeFactory: [String: themeStuff] = [
        "halloween": (["🎃","👻","🦇","😈", "😱","🍬","🍎","🙀","👿","👹"], #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
        "animals" : (["🐶","🐱","🐭","🐰", "🦊","🐻","🐼","🐨","🐯","🦁"], #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)),
        "foods" : (["🍏","🍉","🍓","🍒", "🥝","🍅","🍆","🥑","🍠","🍕"], #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
        "activities" : (["⚽️","⛳️","🥊","🏹", "🏋🏽‍♀️","🏄🏾‍♀️","🚴🏾‍♀️","🥍","🛷","🎿"], #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
        "travel" : (["🚗","🚕","🚙","🚒", "🚐","🛵","🚍","🚘","🚁","🛸"], #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        "objects" : (["📱","📲","💻","🖥", "💿","📸","📞","📺","💾","🕹"], #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    ]
    
    private var newTheme: themeStuff {
        let randomIndex = themeFactory.count.arc4Random
        /// Create an array that has all the keys in the dictionary
        let key = Array(themeFactory.keys)[randomIndex]
        return themeFactory[key]!
    }
    
    private var theme: themeStuff! {
        didSet {
            view.backgroundColor = theme.backgroundColor
            cardButtons.forEach{
                $0.backgroundColor = theme.cardColor
                $0.setTitle("", for: UIControl.State.normal)
            }
            flipCountLabel.textColor = theme.cardColor
            scoreLabel.textColor = theme.cardColor
        }
    }
    
  
    /// Collection of card buttons for the UI
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBAction private func createNewGame(_ sender: UIButton, forEvent event: UIEvent) {
        newGame()
    }
    
    private func newGame() {
        theme = newTheme
        game = Concentration(numberOfPairsOfCards:  (cardButtons.count + 1) / 2)
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
        emoji = [:]
        emojiChoices = theme.emoji
    }
    
    override func viewDidLoad() {
        newGame()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        //When touchCard is pressed, look in that array and find the button being pressed
        //Once I know the index, look up in ANOTHER ARRAY to which emoji should be displayed
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            flipCountLabel.text = "Flips: \(game.flipCount)"
            scoreLabel.text = "Score \(game.score)"
       } else {
        print("chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardColor
            }
        }
    }
    

    
    private lazy var emojiChoices: [String] = { return theme.emoji }()
    
    ///Use emoji dictionary to look up card Identifier to get the emoji that goes on that card
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emojiChoices.count > 0, emoji[card] == nil {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4Random)
            }
    return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4Random: Int {
        switch self {
        case 1...Int.max:
            return Int(arc4random_uniform(UInt32(self)))
        case -Int.max..<0:
            return Int(arc4random_uniform(UInt32(self)))
        default:
            return 0
        }
    }
}



