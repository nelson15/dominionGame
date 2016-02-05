//
//  GameScene.swift
//  DominionSK
//
//  Created by Corey Nelson on 1/17/16.
//  Copyright (c) 2016 Corey Nelson. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
        //        let glowBall = SKShapeNode(circleOfRadius: 100/2)
        //        glowBall.position = CGPoint(x:0, y:0)
        //        glowBall.zPosition = -1
        //        glowBall.glowWidth = 10
        //        glowBall.strokeColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 0.8)
        //        estate.addChild(glowBall)
        //        glowBall.alpha = 0.75
        
        let activePlayer = Player(isLocal: true)
        
        let gameBoard = GameInfo(supplyList:[.Village, .Smithy, .Village, .Smithy, .Village, .Estate, .Duchy, .Gold, .Smithy,.Province], players: [activePlayer])
        gameBoard.position = CGPoint(x:CGRectGetMidX(self.frame)-150, y:(CGRectGetMidY(self.frame)+75))
        self.addChild(gameBoard)
        
        gameBoard.initSupplyPiles()
        gameBoard.renderPlayers()
        
        
    }
    

    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
