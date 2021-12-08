//
//  CardButton.swift
//  SetGame
//
//  Created by Linda adel on 12/1/21.
//

import UIKit

class CardButton: UIButton {

    var card : Card?{
        didSet{
            if card == nil {
                isHidden = true
               setAttributedTitle(NSAttributedString(), for: .normal)
                
            }else{
                setAttributedTitle(titleForCard(card!), for: .normal)
                isHidden = false
            }
        }
    }
    var cardIsSelected : Bool{
        get{
            return layer.borderColor == #colorLiteral(red: 1, green: 0.9978344921, blue: 0.09790472186, alpha: 1)
        }
        set{
            if newValue == true {
                layer.borderWidth = 3.0
                layer.borderColor = #colorLiteral(red: 1, green: 0.9978344921, blue: 0.09790472186, alpha: 1)
            } else {
                layer.borderWidth = 0.0
                layer.borderColor = #colorLiteral(red: 1, green: 0.9978344921, blue: 0.09790472186, alpha: 1)
            }
        }
    }
    func toggleCardsSelection()  {
        cardIsSelected = !cardIsSelected
    }
    private func titleForCard(_ card : Card) -> NSAttributedString{
        var shape : String
        switch card.featureOne {
        case .one:
            shape = "●"
        case .two:
            shape = "■"
        case .three:
            shape = "▲"
        }
        var color : UIColor
        switch card.featureTwo {
        case .one:
            color = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        case .two:
            color = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        case .three:
            color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        }
        var filled : Bool
        switch card.featureThree {
        // Not filled
        case .one:
            filled = false
            color = color.withAlphaComponent(1.0)
        // Shaded
        case .two:
            filled = true
            color = color.withAlphaComponent(0.3)
        // filled
        case .three:
            filled = true
            color = color.withAlphaComponent(1.0)
        
        }
        // number
        switch card.featureFour {
        case .one:
           break
        case .two:
           shape += "" + shape
        case .three:
            shape += "" + shape + "" + shape
        
        }
        let attributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeWidth : 1.0 * (filled ? -1.0 : 5.0),
            NSAttributedString.Key.foregroundColor : color
        ]
        let attributedString = NSAttributedString(string: shape, attributes: attributes)
        return attributedString
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        initialSetUp()
    }
  private func initialSetUp(){
    layer.cornerRadius = frame.width * 0.2
            layer.borderColor = UIColor.lightGray.cgColor
            isHidden = false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }
    
    required init?(coder : NSCoder) {
        super.init(coder: coder)
        initialSetUp()
    }
}
