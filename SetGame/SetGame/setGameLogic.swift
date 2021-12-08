//
//  setGameLogic.swift
//  SetGame
//
//  Created by Linda adel on 12/1/21.
//

import Foundation

struct setGameLogic {
  private(set) var score = 0
  private(set) var deck = Set<Card>()
  private(set) var openCards = Set<Card>()
    
    init() {
        populateDeck()
    }
    
    private mutating func populateDeck(){
        for featureOne in 1...3{
            for featureTwo in 1...3{
                for featureThree in 1...3{
                    for featureFour in 1...3{
                        deck.insert(
                            Card(Card.variable(rawValue: featureOne)!,
                                 Card.variable(rawValue: featureTwo)!,
                                 Card.variable(rawValue: featureThree)!,
                                 Card.variable(rawValue: featureFour)!))
                    }
                    
                }
            
            }
        }
    }
    @discardableResult
    mutating func draw(n : Int) -> Set<Card> {
        var newOpenedCard = Set<Card>()
        for _ in 1...n {
            if let newCard = deck.removeRandomElement() {
                newOpenedCard.insert(newCard)
            }else {
                break
            }
        }
        for card in newOpenedCard {
            openCards.insert(card)
        }
        return newOpenedCard
    }
    @discardableResult
    mutating func draw() ->Card? {
        if let newCard = deck.removeRandomElement() {
            openCards.insert(newCard)
            return newCard
        }
        return nil
    }
    mutating func evaluateCardSet(_ cardOne : Card , _ cardTwo : Card , _ cardThree: Card) -> Bool{
        if !openCards.contains(cardOne) || !openCards.contains(cardTwo) || !openCards.contains(cardThree){
            return false
}
func eveluateVariables (_ variableOne : Card.variable ,_ variableTwo : Card.variable , _ variableThree : Card.variable) -> Bool{
    return ((variableOne == variableTwo && variableOne == variableThree) || (variableOne != variableTwo && variableOne != variableThree && variableTwo != variableThree  ))
        }
        let featureOne = eveluateVariables(cardOne.featureOne , cardTwo.featureOne , cardThree.featureOne)
        let featureTwo = eveluateVariables(cardOne.featureTwo , cardTwo.featureTwo , cardThree.featureTwo)
        let featureThree = eveluateVariables(cardOne.featureThree , cardTwo.featureThree , cardThree.featureThree)
        let featureFour = eveluateVariables(cardOne.featureFour , cardTwo.featureFour , cardThree.featureFour)
        
        let isASet = featureOne && featureTwo && featureThree && featureFour
        score += (isASet ? 3 : -1)
        if isASet {
            if let index = openCards.firstIndex(of: cardOne){
                openCards.remove(at: index)
            }
            if let index = openCards.firstIndex(of: cardTwo){
                openCards.remove(at: index)
            }
            if let index = openCards.firstIndex(of: cardThree){
                openCards.remove(at: index)
            }
        }
        return isASet
    }
}
