//
//  StartGameScene.swift
//  Tri180
//
//  Created by Andrew Nhan on 7/3/15.
//  Copyright (c) 2015 NhanStudios. All rights reserved.
//

import UIKit
import SpriteKit

class StartGameScene: SKScene{
    var soundButton:SKSpriteNode = SKSpriteNode()
    var mutedmaybe:String = ""
    
    override func didMoveToView(view: SKView) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isGamePaused")
        backgroundColor = SKColor.whiteColor()
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
            mutedmaybe = "volume"
        }
        if (NSUserDefaults.standardUserDefaults().boolForKey("muted") == true) {
            mutedmaybe = "muted"
        }
                
        let title = SKSpriteNode(imageNamed: "title")
        title.position = CGPointMake(size.width/2, size.height*0.85)
        addChild(title)
        
        let normalGameButton = SKSpriteNode(imageNamed: "start")
        normalGameButton.position = CGPointMake(size.width/2,size.height/2 - 50)
        normalGameButton.name = "normalgame"
        addChild(normalGameButton)
        
        soundButton = SKSpriteNode(texture: SKTexture(imageNamed: mutedmaybe))
        soundButton.position = CGPointMake(size.width/2, size.height/2 - 150)
        soundButton.name = "sound"
        addChild(soundButton)
        
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        if(touchedNode.name == "normalgame"){
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "retrys")
            let gameOverScene = SelectionScene(size: size)
            gameOverScene.scaleMode = .AspectFill
            let transitionType = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        if(touchedNode.name == "sound") {
            if (NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "muted")
                var soundToMute:[SKTexture] = [SKTexture(imageNamed: "volume"), SKTexture(imageNamed: "mute")]
                var changeSound = SKAction.animateWithTextures(soundToMute, timePerFrame: 0.1)
                self.soundButton.runAction(changeSound)
            }
            else {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "muted")
                var soundToMute:[SKTexture] = [SKTexture(imageNamed: "mute"), SKTexture(imageNamed: "volume")]
                var changeSound = SKAction.animateWithTextures(soundToMute, timePerFrame: 0.1)
                self.soundButton.runAction(changeSound)
            }
        }
        
    }
}