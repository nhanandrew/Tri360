//
//  GameOverScene.swift
//  Tri180
//
//  Created by Andrew Nhan on 6/25/15.
//  Copyright (c) 2015 NhanStudios. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameOverScene: SKScene {
    let gameScene:GameScene = GameScene()
    var GMHighScore:Int = Int()
    var GameMode:String = String()
    
    
    override init(size: CGSize) {
        super.init(size: size)
        if(NSUserDefaults.standardUserDefaults().integerForKey("ad") == 6){
            AppDelegate.showChartboostAds()
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "ad")
        }
        else{
            NSUserDefaults.standardUserDefaults().setInteger(NSUserDefaults.standardUserDefaults().integerForKey("ad")+1, forKey: "ad")
        }
        backgroundColor = SKColor.whiteColor()
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 1){
            self.GMHighScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore1")
            self.GameMode = "Game Mode 1"
        }
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 2){
            self.GMHighScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore2")
            self.GameMode = "Game Mode 2"
        }
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 3){
            self.GMHighScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore3")
            self.GameMode = "Game Mode 3"
        }
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 4){
            self.GMHighScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore4")
            self.GameMode = "Game Mode 4"
        }
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 5){
            self.GMHighScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore5")
            self.GameMode = "Game Mode 5"
        }
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 6){
            self.GMHighScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore6")
            self.GameMode = "Game Mode 6"
        }
        var playerScore = String(format: "Your Score: %i", NSUserDefaults.standardUserDefaults().integerForKey("currentscore"))
        var highScore = String(format: "Highscore: %i", GMHighScore)
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Gameover!"
        label.fontSize = 45
        label.fontColor = SKColor.yellowColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
        addChild(label)
        
        let mode = SKLabelNode(fontNamed: "Chalkduster")
        mode.text = GameMode
        mode.fontSize = 35
        mode.fontColor = SKColor.orangeColor()
        mode.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        addChild(mode)
        
        let pastScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        pastScoreLabel.text = playerScore
        pastScoreLabel.fontSize = 35
        pastScoreLabel.fontColor = SKColor.greenColor()
        pastScoreLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(pastScoreLabel)
        
        
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = highScore
        scoreLabel.fontSize = 35
        scoreLabel.fontColor = SKColor.blueColor()
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        addChild(scoreLabel)
        
        let retryButton = SKSpriteNode(imageNamed: "retry")
        retryButton.position = CGPoint(x: size.width/2 + 75, y: size.height/2 - 200)
        retryButton.name = "retry"
        addChild(retryButton)
        
        let menuButton = SKSpriteNode(imageNamed: "menu")
        menuButton.position = CGPoint(x: size.width/2 - 75, y: size.height/2 - 200)
        menuButton.name = "menu"
        addChild(menuButton)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "menu") {
            runAction(SKAction.sequence([SKAction.runBlock() {
                let reveal = SKTransition.flipVerticalWithDuration(0.5)
                let scene = StartGameScene(size: self.size)
                scene.scaleMode = self.scaleMode
                self.view?.presentScene(scene, transition:reveal)}]))
        }
        if(touchedNode.name == "retry"){
            runAction(SKAction.sequence([SKAction.runBlock(){
                let reveal = SKTransition.flipVerticalWithDuration(0.5)
                let scene = GameScene(size: self.size)
                scene.scaleMode = self.scaleMode
                self.view?.presentScene(scene, transition:reveal)}]))
        
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }}