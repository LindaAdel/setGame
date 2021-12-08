//
//  Card.swift
//  SetGame
//
//  Created by Linda adel on 12/1/21.
//

import Foundation

struct Card {
    enum variable : Int{
        case one = 1
        case two = 2
        case three = 3
    }
    let featureOne : variable
    let featureTwo : variable
    let featureThree : variable
    let featureFour : variable
    
    init(_ featureOne : variable ,_ featureTwo : variable ,_ featureThree : variable ,_ featureFour : variable  ) {
        self.featureOne = featureOne
        self.featureTwo = featureTwo
        self.featureThree = featureThree
        self.featureFour = featureFour
    }
}
extension Card : Hashable{
    var hashValue: Int {
        return featureOne.rawValue ^ featureTwo.rawValue ^ featureThree.rawValue ^ featureFour.rawValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(featureOne.rawValue ^ featureTwo.rawValue ^ featureThree.rawValue ^ featureFour.rawValue)
    }
}
extension Card : Equatable{
    static func == (lhs: Self, rhs: Self) -> Bool{
        return (lhs.featureOne) == (rhs.featureOne) && (lhs.featureTwo) == (rhs.featureTwo) &&
        (lhs.featureThree) == (rhs.featureThree) && (lhs.featureFour) == (rhs.featureFour)
          
    }

}
extension Card : CustomStringConvertible
{
    var description: String {
       return" [\(featureOne.rawValue) ,\(featureTwo.rawValue),\(featureThree.rawValue),\(featureFour.rawValue)]"
    }
    
    
}
