//
//  ViewController.swift
//  SetGame
//
//  Created by Linda adel on 12/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var setGame : setGameLogic!
    let initialCards = 12
    private var selectedCards : [Card]{
        var cards = [Card]()
        for cardButton in cardButtons {
            if cardButton.cardIsSelected {
                if let card = cardButton.card{
                    cards.append(card)}
            }
        }
        return cards
    }
    
    @IBOutlet var cardButtons: [CardButton]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func touchCards(_ sender: CardButton) {
    
        sender.toggleCardsSelection()
        if selectedCards.count == 3{
            let isASet = setGame.evaluateCardSet(selectedCards[0], selectedCards[1] , selectedCards[2])
            if isASet {
               match(selectedCards)
               // sender.backgroundColor = #colorLiteral(red: 1, green: 0.9992292858, blue: 0.2936768713, alpha: 1)
            }else{
                misMatch(selectedCards)
               // sender.backgroundColor = #colorLiteral(red: 1, green: 0.164819691, blue: 0.05892252196, alpha: 1)
            }
            setScore()
        }
    }
    @IBAction func newGame(_ sender: UIButton) {
        scoreLabel.text = " score : \(0)"
        initialSetUp()
    }
    
    @IBAction func deals(_ sender: UIButton) {
        let replacedCards = cleanup()
                
                // Do not deal more cards if cleanup already did it.
                if replacedCards > 0 {
                    print("Not dealing because cleanup already replaced \(replacedCards) cards")
                    return
                }
                
                // How many cards do we want to deal?
                let maxCardsToDeal = 3
                
                // How many cards have we dealt?
                var dealtCards = 0
                
                for cardButton in cardButtons {
                    
                    // Stop when we've dealt enough cards
                    if dealtCards == maxCardsToDeal {
                        return
                    }
                    
                    // If the cardbutton is not set, we can use it to display a new card
                    if cardButton.card == nil {
                        // Try to get a new card from the deck
                        if let newCard = setGame.draw() {
                            // Add the new card in the available button
                            cardButton.card = newCard
                            // Track how many cards we've dealt
                            dealtCards += 1
                        }
                    }
                }    }
    
    private func initialSetUp() {
        for cardButton in cardButtons {
                    cardButton.card = nil
                    cardButton.cardIsSelected = false
                    cardButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
        
       setGame = setGameLogic()
        setGame.draw(n: initialCards)
        for(index , card) in setGame.openCards.enumerated(){
            cardButtons[index].card = card
         
        }
       
        
    }
    func setScore () {
        scoreLabel.text = " score : \(setGame.score)"
    }
    @discardableResult
      private func cleanup() -> Int {
          
          var cardsReplaced = 0
          
          // Cleanup each cardButton
          for cardButton in cardButtons {
              
              // De-highlight button
              cardButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
              
              // If cardButton has a card set, process it
              if cardButton.card != nil {
                  // Replace cards that are no longer open (i.e. the ones that are 'matched')
                  if !setGame.openCards.contains(cardButton.card!) {
                      replaceCardButtonOrHideIt(in: cardButton)
                      cardsReplaced += 1
                  }
              }
          }
          return cardsReplaced
      }
    private func replaceCardButtonOrHideIt(in cardButton: CardButton) {
           
           // Get a new card from the game
           if let newCard = setGame.draw() {
               cardButton.card = newCard
           }
           else {
               print("No cards in deck to replace, hiding card button")
               cardButton.card = nil
           }
           
       }

    
        private func match(_ cards : [Card]) {
        for card in cards {
            if let cardButton = getCardButton(card){
                cardButton.cardIsSelected = false
                cardButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            }

        }

    }
    private func misMatch(_ cards : [Card]) {
        for card in cards {
            if let cardButton = getCardButton(card){
                cardButton.cardIsSelected = false
                cardButton.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }

        }

    }
    private func getCardButton(_ card : Card) -> CardButton?{
        for cardButton in cardButtons {
            if cardButton.card == card {
                return cardButton
            }
        }
        return nil
    }
}

