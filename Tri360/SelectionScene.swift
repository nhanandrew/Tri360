//
//  SelectionScene.swift
//  Tri360
//
//  Created by Andrew Nhan on 8/13/15.
//  Copyright (c) 2015 NhanStudios. All rights reserved.
//

import UIKit
import SpriteKit

class SelectionScene: SKScene {
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        let selectTitle = SKSpriteNode(texture: SKTexture(imageNamed: "mode"))
        selectTitle.position = CGPointMake(size.width/2, size.height*0.95)
        addChild(selectTitle)
        
        let gameOne = SKSpriteNode(texture: SKTexture(imageNamed: "gamemode1"))
        gameOne.position = CGPointMake(size.width/2 - 75, size.height*0.765)
        gameOne.name = "one"
        addChild(gameOne)
        
        let gameTwo = SKSpriteNode(texture: SKTexture(imageNamed: "gamemode2"))
        gameTwo.position = CGPointMake(size.width/2 + 75, size.height*0.765)
        gameTwo.name = "two"
        addChild(gameTwo)
        
        let gameThree = SKSpriteNode(texture: SKTexture(imageNamed: "gamemode3"))
        gameThree.position = CGPointMake(size.width/2 - 75, size.height*0.465)
        gameThree.name = "three"
        addChild(gameThree)
        
        let gameFour = SKSpriteNode(texture: SKTexture(imageNamed: "gamemode4"))
        gameFour.position = CGPointMake(size.width/2 + 75, size.height*0.465)
        gameFour.name = "four"
        addChild(gameFour)
        
        let gameFive = SKSpriteNode(texture: SKTexture(imageNamed: "gamemode5"))
        gameFive.position = CGPointMake(size.width/2 - 75, size.height*0.165)
        gameFive.name = "five"
        addChild(gameFive)
        
        let gameSix = SKSpriteNode(texture: SKTexture(imageNamed: "gamemode6"))
        gameSix.position = CGPointMake(size.width/2 + 75, size.height*0.165)
        gameSix.name = "six"
        addChild(gameSix)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "one"){
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "gamemode")
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = .AspectFill
            let transitionType = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        if(touchedNode.name == "two"){
            NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "gamemode")
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = .AspectFill
            let transitionType = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        if(touchedNode.name == "three"){
            NSUserDefaults.standardUserDefaults().setInteger(3, forKey: "gamemode")
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = .AspectFill
            let transitionType = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        if(touchedNode.name == "four"){
            NSUserDefaults.standardUserDefaults().setInteger(4, forKey: "gamemode")
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = .AspectFill
            let transitionType = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        if(touchedNode.name == "five"){
            NSUserDefaults.standardUserDefaults().setInteger(5, forKey: "gamemode")
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = .AspectFill
            let transitionType = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        if(touchedNode.name == "six"){
            NSUserDefaults.standardUserDefaults().setInteger(6, forKey: "gamemode")
            let gameOverScene = GameScene(size: size)
            gameOverScene.scaleMode = .AspectFill
            let transitionType = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
    }
}
