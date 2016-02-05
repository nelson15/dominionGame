//
//  Player.swift
//  DominionSK
//
//  Created by Corey Nelson on 1/24/16.
//  Copyright © 2016 Corey Nelson. All rights reserved.
//

import Foundation
import SpriteKit


class Player: SKNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    
    var deck: [Card.cardName] = []
    var discard: [Card.cardName] = []
    var hand: playersHand
    var handList: [Card.cardName] = []
    var playArea = SKNode()
    
    var actions: Int = 0
    var buys: Int = 0
    var coins: Int = 0
    
    /*  define if player is local player or opponent. this will determine whether to render an
        opponent node or render the hand and deck etc.*/
    var isLocalPlayer: Bool
    var isOpponent: Bool
    
    init(isLocal: Bool){
        
        
        //define if player is local or not
        isLocalPlayer = isLocal
        isOpponent = !isLocal
        hand = playersHand()
        hand.zPosition = -1
        super.init()
        
        //listen for cards played from hand
        NC.addObserver(self, selector: "playCardFromNotify:", name: cardPlayed, object: nil)
        
        userInteractionEnabled = true
        
        addChild(playArea)
        //build deck and shuffle it
        deck = Array(count: 3, repeatedValue: .Estate)
        let coppers: [Card.cardName] = Array(count: 7, repeatedValue: .Copper)
        deck.appendContentsOf(coppers)
        deck = shuffle(deck)
        
        //draw hand
        if isLocalPlayer {self.addChild(hand)}
        drawHand()

    }
    
    func shuffle(var someCards: [Card.cardName]) -> [Card.cardName]{
        let c = someCards.count
        if c < 2 { return someCards}
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            let swapCard1 = someCards[i]
            let swapCard2 = someCards[j]
            someCards[i] = swapCard2
            someCards[j] = swapCard1
        }
        return someCards
    }
    
    func drawCard(){
        if deck.count == 0 && discard.count == 0 {return}
        if deck.count == 0 { discardIntoDeck() }
        let drawnCard = Card(cardNamed: deck[0])
        drawnCard.inHand = true
        handList.append(deck[0])
        deck.removeAtIndex(0)
        
        if isLocalPlayer{
            hand.addChild(drawnCard)
            sortCardsInHand()
        }
    }

    func drawHand() {
        for _ in 1...5 { drawCard() }
        
    }

    
    func discardIntoDeck() {
        discard = shuffle(discard)
        deck.appendContentsOf(discard)
        discard = []
    }
    
    func sortCardsInHand(){
        let yHandPlacement: Int = 80
        let handBoundLeft: Int = 175
        let handBoundRight: Int = 500
        let handBottom: Double = 0.0
        let handTop: Double = 1.0
        
        let handCount = hand.children.count
        let cardsInHandSpacing: Int = (handBoundRight - handBoundLeft)/handCount
        let stackSpacing = (handTop - handBottom) / Double(handCount)
        
        var cardSpot: Int = 0
        var cardPosition: CGPoint
        for child in hand.children {
            cardPosition = CGPoint(x: handBoundLeft + cardSpot*cardsInHandSpacing, y: yHandPlacement)
            child.zPosition = CGFloat(handBottom + (Double(cardSpot)*stackSpacing))
            let fixCardInHandPos = SKAction.moveTo(cardPosition, duration: 0.2)
            child.runAction(fixCardInHandPos)
            cardSpot = cardSpot + 1
        }
        
    }
    
    // called by player to figure out if they can play the card in question
    func canPlay(cardtoPlay: Card){
        var canBePlayed: Bool = false
        
        //play an action
        if cardtoPlay.cardType == .Action && self.actions >= 1 && cardtoPlay.inHand {
            canBePlayed = true
        }
        
        //play a treasure
        if cardtoPlay.cardType == .Treasure && cardtoPlay.inHand {
            canBePlayed = true
        }
        
        cardtoPlay.canPlay =  canBePlayed
    }
    
    //run thru hand to check for playable cards
    func playableCardsInHand() {
        for element in hand.children as! [Card] {
            canPlay(element)
        }
    }
    
    //called by a player to figure out if the card can be gained
    func canGain(cardToGain: Card){
        var canBeGained: Bool = false
        
        //put rules here NEED RULE FOR IF THERE ARE ZERO CARDS
        if self.coins >= cardToGain.price && cardToGain.inSupply{
            canBeGained = true
        }
        
        cardToGain.canGain =  canBeGained
    }
    
    func playCardFromNotify(notification: NSNotification) {
        let userInfo:Dictionary<String,Card> = notification.userInfo as! Dictionary<String,Card>
        let cardToPlay = userInfo["thiscard"]
        playCardInHand(cardToPlay!)
    }
    
    func playCardInHand(cardToPlay: Card) {
        
        cardToPlay.inHand = false
        cardToPlay.moveToParent(playArea)
        playableCardsInHand()//recheck for playable cards
        
        if cardToPlay.cardType == .Action {self.actions -= 1}
        
        self.actions += cardToPlay.addActions
        self.buys += cardToPlay.addBuys
        self.coins += cardToPlay.addCoins
        if cardToPlay.drawCards > 0 {
            for _ in 1...cardToPlay.drawCards {self.drawCard()}
        }
        
        //add code for playing unique actions from cards, yet to be implemented...
 
    }
   
    deinit {
        NC.removeObserver(self)
    }
    
}