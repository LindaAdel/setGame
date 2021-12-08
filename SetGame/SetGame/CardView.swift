//
//  CardView.swift
//  SetGame
//
//  Created by Linda adel on 12/6/21.
//

import UIKit
// uiview that represent the game card
//to see card in ib 
@IBDesignable
class CardView: UIView {
    @IBInspectable
    var isSelected : Bool = false{
        didSet{ setNeedsDisplay()}
    }
    
    var color : Color?
    var shape : Shape?
    var elementNumber : ElementNumber?
    var shade :Shade?
    
    enum Color {
        case green , red ,purple
        
    }
    enum Shape{
        case squiggle , diamond , oval
    }
    enum Shade {
        case solid , shaded ,unfilled
    }
    enum ElementNumber{
     case one , two , three
    }
    // Redraw the card when the view's frame changes
    override var frame: CGRect {
        didSet{ setNeedsDisplay()}
    }
    override init(frame: CGRect) {
           super.init(frame: frame)
           initialSetup()
       }
       
    // Init with coder (i.e. through storyboard/interface-builder)
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initialSetup()
        }
    // Do custom drawing of the current card containing the 4 enum properties
       
    override func draw(_ rect: CGRect) {
        // Drawing code
        setUpCard()
        if color != nil, shade != nil, elementNumber != nil, shape != nil{
            // Draw each shape (i.e. card might have one, two, or three shapes)
            for rect in getRects(for: elementNumber!) {
                drawContent(rect: rect, shape: shape!, color: color!, shade: shade!)
            }
        }
    }
    // Do any initial setup (called right after init())
       private func initialSetup() {
           isOpaque = false
       }
    // Setup card's general look  (without the actual features)
    private func setUpCard(){
        let cornerRaduis = min(bounds.size.width, bounds.size.height) * 0.1
        let cardPath = UIBezierPath(roundedRect: bounds , cornerRadius: cornerRaduis)
        cardPath.addClip()
        UIColor.white.setFill()
        // draw higlight when slected
        if isSelected {
            cardPath.lineWidth = min(bounds.size.width, bounds.size.height) * 0.1
            #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).setStroke()
        }
        else{
            cardPath.lineWidth = min(bounds.size.width, bounds.size.height) * 0.1
            UIColor.lightGray.setStroke()
        }
        cardPath.fill()
        cardPath.stroke()
    }
    //draw card content
    private func drawContent(rect : CGRect , shape : Shape , color : Color , shade : Shade){
        // Get the shape's path
        let shapePath = path(forShape: shape, in: rect)
        
        // The stroke color we want to use
        let stroke = strokeColor(for: color)
        
        // The fill/shade color we want to use
        let fill = fillColor(for: color, with: shade)
        
        // Set stroke and fill colors
        stroke.setStroke()
        fill.setFill()
        // Set the lineWidth
        shapePath.lineWidth = min(rect.size.width, rect.size.height) * 0.05
        
        // Stroke and fill
        shapePath.fill()
        shapePath.stroke()
    }
    // switch on shape and return path for each shape
    private func path(forShape shape : Shape , in rect : CGRect) -> UIBezierPath {
        switch shape {
        case .squiggle: return squigglePath(in: rect)
        case .diamond : return dimandPath(in: rect)
        case .oval : return ovalPath(in: rect)
        }
    }
    // return color according to case
    private func strokeColor(for color : Color) -> UIColor{
        switch color {
        case .green: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .purple: return #colorLiteral(red: 0.6377331317, green: 0, blue: 0.7568627596, alpha: 1)
        case .red: return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    // fill color in shape according to shade
    private func fillColor(for color : Color , with shade : Shade) -> UIColor{
        let stroke = strokeColor(for: color)
        switch shade {
        case .shaded: return stroke.withAlphaComponent(0.2)
        case .solid : return stroke.withAlphaComponent(1.0)
        case .unfilled : return stroke.withAlphaComponent(0.0)
       
        }
    }
    // draw path for each shape and then switch on shape enum to draw each one
    private func dimandPath(in rect : CGRect) -> UIBezierPath {
        
        let path = UIBezierPath()
        let margin = min(rect.size.width, rect.size.height) * 0.15
        let topCenter = CGPoint(x: rect.midX , y: rect.minY + margin)
        path.move(to: topCenter)
        let centerRight = CGPoint(x: rect.maxX - margin , y: rect.midY )
        path.addLine(to: centerRight)
        let buttomCenter = CGPoint(x: rect.midX , y: rect.maxY - margin)
        path.addLine(to: buttomCenter)
        let centerLeft = CGPoint(x: rect.minX + margin , y: rect.midY )
        path.addLine(to: centerLeft)
        path.close()
        return path
    }
    private func squigglePath(in rect : CGRect) -> UIBezierPath {
        
        let margin = min(rect.size.width, rect.size.height) * 0.15
              let drawingRect = rect.insetBy(dx: margin, dy: margin)
              
              let path = UIBezierPath()
              var point, cp1, cp2: CGPoint

              point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.05, y: drawingRect.origin.y + drawingRect.size.height*0.40)
              path.move(to: point)
              
              point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.35, y: drawingRect.origin.y + drawingRect.size.height*0.25)
              cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.09, y: drawingRect.origin.y + drawingRect.size.height*0.15)
              cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.18, y: drawingRect.origin.y + drawingRect.size.height*0.10)
              path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
              
              point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.75, y: drawingRect.origin.y + drawingRect.size.height*0.30)
              cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.40, y: drawingRect.origin.y + drawingRect.size.height*0.30)
              cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.60, y: drawingRect.origin.y + drawingRect.size.height*0.45)
              path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
              
              point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.97, y: drawingRect.origin.y + drawingRect.size.height*0.35)
              cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.87, y: drawingRect.origin.y + drawingRect.size.height*0.15)
              cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.98, y: drawingRect.origin.y + drawingRect.size.height*0.00)
              path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
              
              point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.45, y: drawingRect.origin.y + drawingRect.size.height*0.85)
              cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.95, y: drawingRect.origin.y + drawingRect.size.height*1.10)
              cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.50, y: drawingRect.origin.y + drawingRect.size.height*0.95)
              path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
              
              point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.25, y: drawingRect.origin.y + drawingRect.size.height*0.85)
              cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.40, y: drawingRect.origin.y + drawingRect.size.height*0.80)
              cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.35, y: drawingRect.origin.y + drawingRect.size.height*0.75)
              path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
              
              point = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.05, y: drawingRect.origin.y + drawingRect.size.height*0.40)
              cp1 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.00, y: drawingRect.origin.y + drawingRect.size.height*1.10)
              cp2 = CGPoint(x: drawingRect.origin.x + drawingRect.size.width*0.005, y: drawingRect.origin.y + drawingRect.size.height*0.60)
              path.addCurve(to: point, controlPoint1: cp1, controlPoint2: cp2)
              return path
    }
    private func ovalPath(in rect : CGRect) -> UIBezierPath {
        let margin = min(rect.size.width, rect.size.height) * 0.15
        let ovalFrame = CGRect(x: rect.origin.x + margin,
                               y: rect.origin.y + margin,
                               width: rect.size.width - (margin*2),
                               height: rect.size.height - (margin*2))
        
        return UIBezierPath(ovalIn: ovalFrame)
    }// Get CGRect(s) for the given number of elements.
    private func getRects(for elements : ElementNumber) -> [CGRect]{
        // Calculate the size for each rect
        let maxsize = max(bounds.size.width, bounds.size.height)
        let sizeOfEachRect = CGSize(width: maxsize/3, height: maxsize/3)
        // The CGRects we'll return
        var rects = [CGRect]()
        switch elements {
        case .one: rects.append(rectForOneElement(sizeOfRect: sizeOfEachRect))
        case .two: rects.append(contentsOf: rectForTwoElement(sizeOfEachRect: sizeOfEachRect))
        case .three: rects.append(contentsOf: rectForThreeElement(sizeOfEachRect: sizeOfEachRect))
        
        }
        return rects
    }

    // Get a CGRect for drawing one element/shape inside the card
    private func rectForOneElement (sizeOfRect : CGSize) -> CGRect{
        let x = bounds.midX - sizeOfRect.width/2
        let y = bounds.midY - sizeOfRect.width/2
        let originPoint = CGPoint(x: x, y: y)
        return CGRect(origin: originPoint, size: sizeOfRect)
        
    }
    //Get two CGRects for drawing 2 elements/shapes inside the card
    //If card's width > card's height:
        //  Rects will be horizontally distributed
        //Else:
        // Rects will be vertically distributed
    private func rectForTwoElement (sizeOfEachRect : CGSize) -> [CGRect]{
        let rectForOne = rectForOneElement(sizeOfRect: sizeOfEachRect)
        // Could be top/bottom or left/right depending on card's bounds.
        let rect1 , rect2: CGRect
        // We have more width than height, distribute them horizontally x axis
        if bounds.width > bounds.height {
            rect1 = rectForOne.offsetBy(dx: sizeOfEachRect.width/2, dy: 0)
            rect2 = rectForOne.offsetBy(dx: -(sizeOfEachRect.width/2), dy: 0)
        }// We have more height than width, distribute them vertically y axis
        else {
            rect1 = rectForOne.offsetBy(dx: 0 , dy: sizeOfEachRect.width/2)
            rect2 = rectForOne.offsetBy(dx: 0 , dy: -(sizeOfEachRect.width/2))
        }
        return [rect1 , rect2]
    }
    //Get two CGRects for drawing 3 elements/shapes inside the card
    //If card's width > card's height:
        //  Rects will be horizontally distributed
        //Else:
        // Rects will be vertically distributed
    private func rectForThreeElement (sizeOfEachRect : CGSize) -> [CGRect]{
        // The rect for the element in the center is the same for 1 or 3 elements
        let centerRect = rectForOneElement(sizeOfRect: sizeOfEachRect)
        // Could be top/bottom or left/right depending on card's bounds.
        let rect1, rect2: CGRect
        // We have more width than height, distribute them horizontally x axis
        if bounds.width > bounds.height {
            rect1 = CGRect(x: centerRect.minX - sizeOfEachRect.width,
                           y: centerRect.minY,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
            rect2 = CGRect(x: centerRect.maxX,
                           y: centerRect.minY,
                           width: sizeOfEachRect.width,
                           height: sizeOfEachRect.height)
        }// We have more height than width, distribute them vertically y axis
        else {
            rect1 = CGRect(x: centerRect.minX,
                                       y: centerRect.minY - sizeOfEachRect.height,
                                       width: sizeOfEachRect.width,
                                       height: sizeOfEachRect.height)
                        
                        rect2 = CGRect(x: centerRect.minX,
                                       y: centerRect.maxY,
                                       width: sizeOfEachRect.width,
                                       height: sizeOfEachRect.height)
        }
        return [centerRect , rect1 , rect2]
    }

// Represents the state of a card in the current game:
   // "matched" card will show in a "green/success" accent/highlight color.
   // "mismatched" card will show in a "red/failed" accent/highlight color.
   // "regular" card will show with no accent/highlight color.
  
   enum CardState {
       // Regular state (i.e. when starting a game)
       case regular
       // Matched state (the card was correclty selected as part of a valid set)
       case matched
       // Mismatched state (the card was incorreclty selected as part of a set)
       case mismatched
   }
// current card state
var cardState : CardState{
   
    get{
        if layer.borderColor == #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) {return .matched}
        else if layer.borderColor == #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) {return .mismatched}
        else {return .regular}
    }
    set{
        switch newValue {
        case .regular:
            // regular state card
           layer.borderWidth = 0.0
           layer.borderColor = UIColor.clear.cgColor
        case.matched:
            // matched state card
            layer.borderWidth = (bounds.width)*0.1
            layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case.mismatched:
            // mismatched state card
            layer.borderWidth = (bounds.width)*0.1
            layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
        }
    }
 }
}
