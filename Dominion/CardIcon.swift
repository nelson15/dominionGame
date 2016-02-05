//
//  CardIcon.swift
//  Dominion
//
//  Created by Corey Nelson on 2/1/16.
//  Copyright © 2016 Corey Nelson. All rights reserved.
//

import Foundation
import SpriteKit


class cardIcon: SKNode {
    
    let playersInGame: Int
    let supplyCard: Card.cardName
    var supplyCount: Int = 0
    
    let supplyIcon: Card
    let supplyTicker = SKLabelNode()
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(theCard: Card.cardName,  playerCount: Int) {
        
        playersInGame = playerCount
        supplyCard = theCard
        supplyIcon = Card(cardNamed: theCard)
        supplyIcon.userInteractionEnabled = false
        
        super.init()
        
        supplyCount = self.setSupplyCount()

        self.addChild(supplyIcon)
        renderSupplyTicker()
        
        
    }
    
    
    func setSupplyCount() -> Int {
        var count = 0
        
        switch supplyIcon.cardType {
        case .Action:
            count = 8
        case .Treasure:
            switch supplyIcon.cardID {
            case .Copper:
                count = 60 - 7 * playersInGame
            case .Silver:
                count = 40
            case .Gold:
                count = 20
            default:
                count = 8
            }
        case .Victory:
            switch supplyIcon.cardID {
            case .Estate:
                count = 24
            case .Curse:
                switch playersInGame {
                case 2:
                    count = 10
                case 3:
                    count = 20
                default:
                    count = 30
                }
            default:
                switch playersInGame {
                case 1,2:
                    count = 8
                default:
                    count = 12
                }
            }
        }
        return count
    }
    
    //code for a tiny circle with a ticker inside it to count the cards
    func renderSupplyTicker() {
        let counterBacking = SKShapeNode(circleOfRadius: CGFloat(8))
        
        supplyTicker.zPosition = -2
        supplyTicker.name = "\(supplyCard)Ticker"
        supplyTicker.fontSize = 12
        supplyTicker.position = CGPoint(x: -30, y: -30)
        supplyTicker.fontColor = SKColor.blackColor()
        supplyTicker.text = "\(supplyCount)"
        supplyTicker.fontName = "SnellRoundhand-Black"
        
        counterBacking.zPosition = -2
        counterBacking.position = CGPoint(x: 0, y: 5)
        counterBacking.fillColor = SKColor(colorLiteralRed: 210/255, green: 180/255, blue: 140/255, alpha: 1)
        
        supplyTicker.addChild(counterBacking)
        self.addChild(supplyTicker)
    }
    
    
}