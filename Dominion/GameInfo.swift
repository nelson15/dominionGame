//
//  GameInfo.swift
//  DominionSK
//
//  Created by Corey Nelson on 1/21/16.
//  Copyright © 2016 Corey Nelson. All rights reserved.
//

import Foundation
import SpriteKit

class GameInfo: SKNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    //various lists important to the gameboard
    //info about all the piles of supplies, treasures and victories
    var supplyIcons: [cardIcon] = []
    var treasureIcons: [cardIcon] = []
    var victoryIcons: [cardIcon] = []
    var supplyCount: [Int] = []
    var treasureCount: [Int] = []
    var victoryCount: [Int] = []
    
    var playerList: [Player]
    var activePlayer: Player
    
    let supplySpacing: Int = 65
    
    init(supplyList: [Card.cardName], players: [Player]){
        playerList = players
        activePlayer = playerList[0]

        super.init()
    
        //initilize supply tiles
        renderSupplyIcons(supplyList)
        
        //initialize treasure piles
        renderTresureIcons()
        
        //initialize victory piles
        renderVictoryIcons()
        PlayerTurn()

    }
    
    func renderPlayers() {
        for people in playerList {
            scene!.addChild(people)
        }
    }
    
    func renderSupplyIcons(supplyList: [Card.cardName]){
        //initialize supply icons
        for element in supplyList  {
            supplyIcons.append(cardIcon(theCard: element, playerCount: self.playerList.count))
        }
        
        //layout positions of supply icons
        var xpos = 0
        var ypos = 0
        var cardCount = 0
        for element in supplyIcons{
            cardCount += 1
            element.position = CGPoint(x: xpos, y: ypos)
            xpos += supplySpacing
            if cardCount == 5 {
                ypos = supplySpacing
                xpos = 0
            }
            element.zPosition = 0
            element.userInteractionEnabled = false //make supply icons immovable
            self.addChild(element) //draw supply icons
        }
    }
    
    func renderTresureIcons() {
        let tresureList: [Card.cardName] = [.Gold, .Silver, .Copper]
        for element in tresureList{
            treasureIcons.append(cardIcon(theCard: element, playerCount: self.playerList.count))
        }
        
        //layout positions of treasure piles
        let Txpos = 5 * supplySpacing + 50
        var Typos = supplySpacing
        for element in treasureIcons {
            element.position = CGPoint(x: Txpos, y: Typos)
            element.zPosition = 0
            Typos -= supplySpacing
            
            element.userInteractionEnabled = false //disallow moving treasure icons
            
            self.addChild(element) //draw treasure icon
        }

    }
    
    func renderVictoryIcons() {
        let victoryList: [Card.cardName] = [.Province, .Duchy, .Estate, .Curse]
        for element in victoryList {
            victoryIcons.append(cardIcon(theCard: element, playerCount: self.playerList.count))
        }
        
        //layout positions of victory piles
        let Vxpos = 6 * supplySpacing + 50
        var Vypos = supplySpacing
        for element in victoryIcons {
            element.position = CGPoint(x: Vxpos, y: Vypos)
            Vypos -= supplySpacing
            
            element.zPosition = 0
            element.userInteractionEnabled = false //disallow moving icons
            self.addChild(element)  //draw victory icon

        }
    }
    
    //code for a tiny circle with a ticker inside it to count the cards
    func renderSupplyCounter(icon: Card) {
        let counterBacking = SKShapeNode(circleOfRadius: CGFloat(14))
        let counterTicker = SKLabelNode()
 
        counterTicker.zPosition = -2
        counterTicker.name = "\(icon.cardID)Ticker"
        counterTicker.fontSize = 20
        counterTicker.position = CGPoint(x: -45, y: -45)
        counterTicker.fontColor = SKColor.blackColor()
        counterTicker.text = "\(0)"
        counterTicker.fontName = "SnellRoundhand-Black"
        
        counterBacking.zPosition = -2
        counterBacking.position = CGPoint(x: 0, y: 5)
        counterBacking.fillColor = SKColor(colorLiteralRed: 210/255, green: 180/255, blue: 140/255, alpha: 1)

        counterTicker.addChild(counterBacking)
        icon.addChild(counterTicker)
    }

    //returns a supply card to be drawn on top of one of the supply icons.
    func addSupply(theCard: cardIcon) {
        let returnCard = Card(cardNamed: theCard.supplyCard)
        returnCard.inSupply = true
        returnCard.zPosition = 1
        returnCard.position = convertPoint(theCard.position, toNode: scene!)
        returnCard.name = "\(theCard.supplyCard)"
        scene!.addChild(returnCard)
    }
    
    
    /*  
        adds supply piles on top of each icon, these nodes are decended from the scene so this fxn
        must be called from the gamescene.swift
    */
    func initSupplyPiles() {
        //fill all supply piles and set supply inventory to 8
        for element in supplyIcons {
            addSupply(element)
            supplyCount.append(element.supplyCount)
        }
        
        for element in victoryIcons {
            addSupply(element)
        }
        
        for element in treasureIcons {
            addSupply(element)
        }
    }
    
    
    
    //checks if there are any provinces left or if there are 3 empty piles
    func endGame() -> Bool {
       var gameIsEnded = false
        
        
        return gameIsEnded
    }
    
    
    func PlayerTurn() {
        activePlayer.playableCardsInHand()
        
    }
    
    
}