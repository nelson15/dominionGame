//
//  Card.swift
//  DominionSK
//
//  Created by Corey Nelson on 1/17/16.
//  Copyright © 2016 Corey Nelson. All rights reserved.
//

import Foundation
import SpriteKit


class Card: SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    let theScale: CGFloat = 0.6
    
    //define card attributes
    let price: Int
    let addActions: Int
    let addBuys: Int
    let addCoins: Int
    let victoryPts: Int
    let drawCards: Int
    let cardID: cardName
    let cardType: cardTypes
    let supplyQuantity: Int
    
    //define location attributes
    var inHand: Bool = false
    var inSupply: Bool = false
    var canGain: Bool = false
    var canPlay: Bool = false
    var currentLocation: CGPoint
    
    //this card type enum will be helpful in coloring the cards and figuring out when and what cards can be played
    enum cardTypes: Int {
        case Victory = 1
        case Action
        case Treasure
    }
    
    //this enum should make it easy to reference card names
    enum cardName: Int {
        case Estate = 1, Duchy, Province, Curse
        case Copper, Silver, Gold
        case Village, Smithy
        
    //not yet implemented, need to figure out how to implement generic function for special effects
    func cardProps(){
            
        }
    }
    

    
    //make the card with a cardName passed in
    init(cardNamed: cardName) {
        
        let frontTexture: SKTexture
        //let backTexture: SKTexture
        //var largeTexture: SKTexture?
        //let largeTextureFilename: String
        let clear = UIColor.clearColor()
        
        cardID = cardNamed
        
        switch cardNamed {
        case .Estate:
            frontTexture = SKTexture(imageNamed: "victory_estate_100px.png")
            //frontTexture = "small_victory_estate.png"
            //largeTextureFilename = "card_victory_estate_LARGE.png"
            price = 2
            addActions = 0
            addBuys = 0
            addCoins = 0
            drawCards = 0
            victoryPts = 1
            supplyQuantity = 8
            cardType = .Victory
            
        case .Duchy:
            frontTexture = SKTexture(imageNamed: "victory_duchy_100px.png")
            //frontTexture = "small_victory_duchy.png"
            price = 5
            addActions = 0
            addBuys = 0
            addCoins = 0
            drawCards = 0
            victoryPts = 3
            supplyQuantity = 8
            cardType = .Victory
            
        case .Province:
            frontTexture = SKTexture(imageNamed: "victory_province_100px.png")
            //frontTexture = "small_victory_province.png"
            price = 8
            addActions = 0
            addBuys = 0
            addCoins = 0
            drawCards = 0
            victoryPts = 6
            supplyQuantity = 8
            cardType = .Victory
            
        case .Curse:
            frontTexture = SKTexture(imageNamed: "victory_curse_100px.png")
            //frontTexture = "small_victory_curse.png"
            price = 0
            addActions = 0
            addBuys = 0
            addCoins = 0
            drawCards = 0
            victoryPts = -1
            supplyQuantity = 10
            cardType = .Victory
            
        case .Copper:
            frontTexture = SKTexture(imageNamed: "treasure_copper_100px.png")
            //frontTexture = "small_coin_copper.png"
            price = 0
            addActions = 0
            addBuys = 0
            addCoins = 1
            drawCards = 0
            victoryPts = 0
            supplyQuantity = 60
            cardType = .Treasure
            
        case .Silver:
            frontTexture = SKTexture(imageNamed: "treasure_silver_100px.png")
            //frontTexture = "small_coin_silver.png"
            price = 3
            addActions = 0
            addBuys = 0
            addCoins = 2
            drawCards = 0
            victoryPts = 0
            supplyQuantity = 40
            cardType = .Treasure
            
            
        case .Gold:
            frontTexture = SKTexture(imageNamed: "treasure_gold_100px.png")
            //frontTexture = "small_coin_gold.png"
            price = 6
            addActions = 0
            addBuys = 0
            addCoins = 3
            drawCards = 0
            victoryPts = 0
            supplyQuantity = 30
            cardType = .Treasure
            
        case .Village:
            frontTexture = SKTexture(imageNamed: "action_village_100px.png")
            //frontTexture = "small_action_village.png"
            price = 3
            addActions = 2
            addBuys = 0
            addCoins = 0
            drawCards = 1
            victoryPts = 0
            supplyQuantity = 10
            cardType = .Action
            
        case .Smithy:
            frontTexture = SKTexture(imageNamed: "action_smithy_100px.png")
            //frontTexture = "small_action_smithy.png"
            price = 4
            addActions = 0
            addBuys = 0
            addCoins = 0
            drawCards = 3
            victoryPts = 0
            supplyQuantity = 10
            cardType = .Action
        }
        
        currentLocation = CGPoint(x: 0, y: 0)
        super.init(texture: frontTexture, color: clear, size: frontTexture.size())

        userInteractionEnabled = true
        xScale = theScale
        yScale = theScale        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(scene!)
            self.currentLocation = self.position //so the card will snap back to its old place
            let touchedNode = nodeAtPoint(location)
            touchedNode.zPosition = 15
            xScale = theScale * 1.2
            yScale = theScale * 1.2
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(scene!)
            let touchedNode = nodeAtPoint(location)
            touchedNode.position = location
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _ in touches {
//            let location = touch.locationInNode(scene!)
//            let touchedNode = nodeAtPoint(location)
            zPosition = 1
            xScale = theScale
            yScale = theScale
            
            //gain a card moving it from supply pile to discard pile
            if self.inSupply && self.position.y < 190 && self.position.x < 530 && canGain {
                //need to add rule about player having buys and enough money for the card
                
                let moveToDiscard = SKAction.moveTo(CGPoint(x: 50,y: 50+65), duration: 0.2)
                self.runAction(moveToDiscard)
            }
            else  if inHand && canPlay && position.y > 150 {
                NC.postNotificationName(cardPlayed, object: nil, userInfo: ["thiscard": self])
            }
            else {
                let snapToOldPosition = SKAction.moveTo(self.currentLocation, duration: 0.2)
                self.runAction(snapToOldPosition)
            }
            
        }
    }

}
