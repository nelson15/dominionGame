//
//  GameButton.swift
//  Dominion
//
//  Created by Corey Nelson on 1/28/16.
//  Copyright © 2016 Corey Nelson. All rights reserved.
//

import Foundation
import SpriteKit

class   Button: SKLabelNode {
    //renders all the buttons necessary in-game.. hopefully!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }//still don't know why I need this..
    
    enum buttonType: Int {
        case drawAHand = 1
        case drawACard
        case listDiscard
    }
    let actionType: buttonType
    var activePlayer: Player
    
    init(action: buttonType, player: Player){
        actionType = action
        activePlayer = player
        super.init()

        switch  actionType {
        case .drawAHand:
            self.text = "Draw Hand"
            player.drawHand()
        case .drawACard:
            self.text = "Draw a Card"
            player.drawCard()
        case .listDiscard:
            self.text = "List Discard"
        }
        self.fontSize = 18
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Loop over all the touches in this event
        for touch in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(scene!)
            let touchedNode = nodeAtPoint(location)
            // Check if the location of the touch is within the button's bounds
            if self == touchedNode {
                switch  actionType {
                case .drawAHand:
                    activePlayer.drawHand()
                case .drawACard:
                    activePlayer.drawCard()
                case .listDiscard:
                    print("\(activePlayer.deck)")
                }
            }
        }
    }
}
