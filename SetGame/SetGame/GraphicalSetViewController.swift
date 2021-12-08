//
//  GraphicalSetViewController.swift
//  SetGame
//
//  Created by Linda adel on 12/6/21.
//

import UIKit

class GraphicalSetViewController: UIViewController {
    // MARK: IBoutlets
    // The boardView is a view containing all the cardViews
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: Private stored-properties
    // instance from game model
    private var setGame : setGameLogic!
    // Keep track of which Card represents which CardView.
    // The cardViews are the actual UIViews shown on screen.
    private var board : [Card : CardView] = [:]
    private let initialCards = 9
    
    //MARK: computed properties
    // Returns the list of cards that are currently selected
    private var selectedCards : [Card]{
        var tappedCard = [Card]()
        for (card , cardView) in board {
            if cardView.isSelected
            {
                tappedCard.append(card)
            }
        }
        return tappedCard
    }
    
    //MARK:  Method overrides
    override func viewDidLoad() {
        super.viewDidLoad()
       newGame()
        // Do any additional setup after loading the view.
    }
    // for updating sub views when device rotate
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
       
    //MARK: IBActions
    // Create a new game. Updates the boardView, board, scoreLabel,
    @IBAction private func newGameTapped() {
      newGame()
    }
    
   
    @IBAction private func dealsTapped() {
        reSetBoard()
        setGame.draw(n: 3)
        updateUI()
    }
    //MARK: functions
    private func updateUI() {
        updateScoreLabel()
        //update open cards in board dictionary
        updateBoard()
        //update open cards in board ui view
        updateBoardView()
        
        
    }
    //MARK:  Method
    private func newGame() {
        boardView.subviews.forEach{$0.removeFromSuperview()}
            board = [:]
            setGame = setGameLogic()
            setGame.draw(n: initialCards)
            updateUI()
    }
    private func updateScoreLabel() {
           scoreLabel.text = "Score: \(setGame.score)"
       }
    // Add missing open cards into the board dictionary. if new cards were dealt recently  we need to add them into board.
    
    private func updateBoard() {
        for card in setGame.openCards{
            if board[card] == nil {
                board[card] = getACardView(for: card)
            }
        }
       }
    // Update the cardViews from the boardView
    private func updateBoardView() {
         //grid to display cards on screen
        guard let grid = gridForCurrentBoard() else {
            return
        }
        // update each cardView
        for (i , card) in board.enumerated() {
            // Get a frame to place the cardView
            if let cardFrame = grid[i] {
                let cardView = card.value
                // Add a little margin to have spacing between cards
                let margin = min(cardFrame.width, cardFrame.height) * 0.05
                cardView.frame = cardFrame.insetBy(dx: margin, dy: margin)
                // If the cardView hasn't been added to the boardView, add it,when new cards have been recently dealt/opened
                if !boardView.subviews.contains(cardView) {
                                    boardView.addSubview(cardView)
                                }
            }
        }
           
       }
    // Returns a Grid object based on the current number of cards present in the board
        private func gridForCurrentBoard() -> Grid?{
            let (rows , columns) = getRowsAndColumns(numberOfCards: board.count)
            guard rows>0, columns>0 else {
                return nil
            }
            return Grid(layout: .dimensions(rowCount: rows, columnCount: columns), frame: boardView.bounds)
        }
    // Get the number of rows and columns that will correctly fit the given numberOfCards.
    private func getRowsAndColumns(numberOfCards : Int ) -> (rows : Int , columns : Int) {
        if numberOfCards <= 0 {return (0,0)}
       var rows = Int(sqrt(Double(numberOfCards)))
        if (rows*rows) < numberOfCards { rows += 1 }
        var columns = rows
        if (rows*(columns - 1)) >= numberOfCards { columns -= 1 }
        return (rows , columns)
    }
    private func getACardView(for card : Card) -> CardView {
        // The view to populate/return
        let cardView = CardView(frame: CGRect())
        // Color
               switch card.featureOne {
               case .one: cardView.color = .red
               case .two: cardView.color = .purple
               case .three: cardView.color = .green
               }
               
               // Shade
               switch card.featureTwo {
               case .one: cardView.shade = .solid
               case .two: cardView.shade = .shaded
               case .three: cardView.shade = .unfilled
               }
               
               // Shape
               switch card.featureThree {
               case .one: cardView.shape = .oval
               case .two: cardView.shape = .diamond
               case .three: cardView.shape = .squiggle
               }
               
               // Number of elements in the card
               switch card.featureFour {
               case .one: cardView.elementNumber = .one
               case .two: cardView.elementNumber = .two
               case .three: cardView.elementNumber = .three
               }
        addTapGestureRecognizers(cardView)
        return cardView
    }
    //MARK:  add tap gesture
    // adding the tap gesture to each card view
    private func addTapGestureRecognizers(_ cardView : CardView){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(flipCard(_:)))
        cardView.addGestureRecognizer(tapRecognizer)
    }
    //action that happens when the user taps on a card
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            if let tappedCardView = sender.view as? CardView {
                // Toggle card selection
                tappedCardView.isSelected = !tappedCardView.isSelected
                checkBoard()
            }
        default:
            break
        }
    }
  //  Cleanup board (remove matched cards from board, de-highlight unmatched cards)
    private func reSetBoard(){
        for (card , cardView) in board {
            // If the game doesn't contain the card, we need to remove it from the baordView.
            // This happends when the card is part of a currently highlighed set that was matched on the previous turn.
            if !setGame.openCards.contains(card) {
                // Remove value from board
                board.removeValue(forKey: card)
                // Remove cardView from superView
                cardView.removeFromSuperview()
                // We just removed a cardView from the superView, update UI!
                updateUI()
            }
            // Set card to be in "regular" state (i.e. not mathced/mismatched)
            // (matched ones shoud no longer be on screen, but mismatched ones should,
            // and we want to "reset" them to a regular state)
            cardView.cardState = .regular
        }
    }
    // reset board and check match/mismatch of cards
    private func checkBoard() {
        //(remove matched cards from board, de-highlight unmatched cards)
      reSetBoard()
        // when there is 3 selected card check match/mismatch
        if selectedCards.count == 3 {
            let isASet = setGame.evaluateCardSet(selectedCards[0], selectedCards[1], selectedCards[2])
            if isASet {
                match(selectedCards)
            }else {
                mismatch(selectedCards)
            }
            // Keep UI in sync with the model
            updateUI()
        }
    }//Deselect card Set it into a "matched" state
    private func match(_ cards : [Card]) {
        for card in cards {
            if let cardView = board[card] {
                cardView.isSelected = false
                cardView.cardState = . matched
            }
        }
    }
    //Deselect card Set it into a "mismatched" state
    private func mismatch(_ cards : [Card]) {
        for card in cards {
            if let cardView = board[card] {
                cardView.isSelected = false
                cardView.cardState = . mismatched
            }
        }
    }
}

