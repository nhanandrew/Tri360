//
//  GameScene.swift
//  Tri180
//
//  Created by Andrew Nhan on 6/21/15.
//  Copyright (c) 2015 NhanStudios. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mainTriangle:SKSpriteNode!
    var trianglePositions:[String] = ["triangleOne","triangleTwo","triangleThree","triangleFour","triangleFive","triangleSix"]
    var triangleColors:[String] = ["red","purple","blue","green","yellow","orange"]
    var referenceColors:[String] = ["red","purple","blue","green","yellow","orange"]
    var triangleColors5 = [["red0orange","red0purple","red0green","red0blue","red0yellow"],["purple0red", "purple0orange", "purple0green", "purple0blue", "purple0yellow"],["blue0green","blue0red","blue0yellow","blue0orange","blue0purple"],["green0red","green0blue","green0purple","green0yellow","green0orange"],["yellow0blue","yellow0red","yellow0green","yellow0purple","yellow0orange"],["orange0red","orange0blue","orange0purple","orange0green","orange0yellow"]]
    var referenceColors5 = [["red0orange","red0purple","red0green","red0blue","red0yellow"],["purple0red", "purple0orange", "purple0green", "purple0blue", "purple0yellow"],["blue0green","blue0red","blue0yellow","blue0orange","blue0purple"],["green0red","green0blue","green0purple","green0yellow","green0orange"],["yellow0blue","yellow0red","yellow0green","yellow0purple","yellow0orange"],["orange0red","orange0blue","orange0purple","orange0green","orange0yellow"]]
    var triangleColors6 = [["orange0red","purple0red","green0red","blue0red","yellow0red"],["red0purple", "orange0purple", "green0purple", "blue0purple", "yellow0purple"],["green0blue","red0blue","yellow0blue","orange0blue","purple0blue"],["red0green","blue0green","purple0green","yellow0green","orange0green"],["blue0yellow","red0yellow","green0yellow","purple0yellow","orange0yellow"],["red0orange","blue0orange","purple0orange","green0orange","yellow0orange"]]
    var referenceColors6 = [["orange0red","purple0red","green0red","blue0red","yellow0red"],["red0purple", "orange0purple", "green0purple", "blue0purple", "yellow0purple"],["green0blue","red0blue","yellow0blue","orange0blue","purple0blue"],["red0green","blue0green","purple0green","yellow0green","orange0green"],["blue0yellow","red0yellow","green0yellow","purple0yellow","orange0yellow"],["red0orange","blue0orange","purple0orange","green0orange","yellow0orange"]]
    var evilCircles:[String] = []
    var score:Int = 0
    var evilSpeed:CGFloat = 1.75
    var oldSpeed:CGFloat = 1.75
    var realScore:UILabel!
    var turnRightButton:SKSpriteNode!
    var turnLeftButton:SKSpriteNode!
    var pauseGameButton:SKSpriteNode!
    var correctSoundAction:SKAction!
    var loseSoundAction:SKAction!
    var resumeButton:SKSpriteNode = SKSpriteNode()
    var pausedLabel:UILabel = UILabel()
    
    struct PhysicsCategory {
        static let None: UInt32 = 0
        static let All: UInt32 = UInt32.max
        static let Evil: UInt32 = 0b1
        static let Triangle: UInt32 = 0b10
    }
    
    override func didMoveToView(view: SKView) {
        setUpAudio()
        backgroundColor = SKColor.whiteColor()
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isGamePaused")
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 2) {
            self.triangleColors = ["red0","purple0","blue0","green0","yellow0","orange0"]
            self.referenceColors = ["red0","purple0","blue0","green0","yellow0","orange0"]
            self.trianglePositions = ["triangleOne0","triangleTwo0","triangleThree0","triangleFour0","triangleFive0","triangleSix0"]
        }
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 3) {
            self.triangleColors = ["red0","purple0","blue0","green0","yellow0","orange0"]
            self.referenceColors = ["red0","purple0","blue0","green0","yellow0","orange0"]
        }
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 4) {
            self.trianglePositions = ["triangleOne0","triangleTwo0","triangleThree0","triangleFour0","triangleFive0","triangleSix0"]
        }
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 5) {
            self.evilSpeed = 2.0
            self.oldSpeed = 2.0
        }
        
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 6) {
            self.trianglePositions = ["triangleOne0","triangleTwo0","triangleThree0","triangleFour0","triangleFive0","triangleSix0"]
            self.evilSpeed = 2.0
            self.oldSpeed = 2.0
        }
        
        self.resumeButton = SKSpriteNode(texture: SKTexture(imageNamed: "play"))
        self.resumeButton.position = CGPointMake(size.width/2, size.height/2)
        self.resumeButton.name = "resumePressed"
        
        self.pausedLabel = UILabel(frame: CGRectMake(size.width/2 - 40, frame.midY-100, 100, 50))
        self.pausedLabel.text = "Paused"
        self.pausedLabel.font = UIFont(name: "Chalkduster", size: 20)
        
        self.realScore = UILabel(frame: CGRectMake(0, 0, 125, 50))
        self.realScore.textAlignment = NSTextAlignment.Center
        self.realScore.font = UIFont(name: "Chalkduster", size: 20)
        self.realScore.text = String(format: "Score: %i", self.score)
        self.view!.addSubview(realScore)
        
        self.pauseGameButton = SKSpriteNode(texture: SKTexture(imageNamed: "pause"))
        self.pauseGameButton.position = CGPointMake(size.width*0.92, size.height*0.95)
        self.pauseGameButton.name = "pauseGamePressed"
        addChild(self.pauseGameButton)
        
        self.turnLeftButton = SKSpriteNode(texture: SKTexture(imageNamed: "turnleftarrow"))
        self.turnLeftButton.position = CGPointMake(size.width*0.13, size.height*0.3)
        self.turnLeftButton.name = "turnLeftName"
        addChild(self.turnLeftButton)
        
        self.turnRightButton = SKSpriteNode(texture: SKTexture(imageNamed: "turnrightarrow"))
        self.turnRightButton.position = CGPointMake(size.width*0.87, size.height*0.3)
        self.turnRightButton.name = "turnRightName"
        addChild(self.turnRightButton)
        
        self.mainTriangle = SKSpriteNode(texture: SKTexture(imageNamed: trianglePositions[0]))
        self.mainTriangle.position = CGPoint(x: frame.midX, y: size.height*0.25)
        addChild(self.mainTriangle)
        
        self.mainTriangle.physicsBody = SKPhysicsBody(rectangleOfSize: self.mainTriangle.size)
        self.mainTriangle.physicsBody!.dynamic = true
        self.mainTriangle.physicsBody!.categoryBitMask = PhysicsCategory.Triangle
        self.mainTriangle.physicsBody!.contactTestBitMask = PhysicsCategory.Evil
        self.mainTriangle.physicsBody!.collisionBitMask = PhysicsCategory.None
        self.mainTriangle.physicsBody!.usesPreciseCollisionDetection = true
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        func addEvil() {
            if(NSUserDefaults.standardUserDefaults().boolForKey("isGamePaused") == false) {
                if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 1){
                    var randColor:Int = Int(arc4random_uniform(6))
                    var color = referenceColors[randColor]
                    let evil = SKSpriteNode(imageNamed: color)
                    var num = 0
                    
                    evil.position = CGPoint(x: frame.midX, y: size.height + evil.yScale/2)
                    evilCircles.append(color)
                    addChild(evil)
                    
                    evil.physicsBody = SKPhysicsBody(rectangleOfSize: evil.size)
                    evil.physicsBody!.dynamic = false
                    evil.physicsBody!.categoryBitMask = PhysicsCategory.Evil
                    evil.physicsBody!.contactTestBitMask = PhysicsCategory.Triangle
                    evil.physicsBody!.collisionBitMask = PhysicsCategory.None
                    num++
                    if (self.score > 50) {
                        self.evilSpeed = 1.5
                        self.oldSpeed = 1.5
                    }
                    
                    if (self.score > 100) {
                        self.evilSpeed = 1.25
                        self.oldSpeed = 1.25
                }
                let actionMove = SKAction.moveTo(CGPoint(x: frame.midX, y: -evil.yScale/2), duration: NSTimeInterval(self.evilSpeed))
                let actionMoveDone = SKAction.removeFromParent()
                
                evil.runAction(SKAction.sequence([actionMove, actionMoveDone]))
                }
                if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 2){
                    var randColor:Int = Int(arc4random_uniform(6))
                    var color = referenceColors[randColor]
                    let evil = SKSpriteNode(imageNamed: color)
                    var num = 0
                    
                    evil.position = CGPoint(x: frame.midX, y: size.height + evil.yScale/2)
                    evilCircles.append(color)
                    addChild(evil)
                    
                    evil.physicsBody = SKPhysicsBody(rectangleOfSize: evil.size)
                    evil.physicsBody!.dynamic = false
                    evil.physicsBody!.categoryBitMask = PhysicsCategory.Evil
                    evil.physicsBody!.contactTestBitMask = PhysicsCategory.Triangle
                    evil.physicsBody!.collisionBitMask = PhysicsCategory.None
                    num++
                    
                    if (self.score > 50) {
                        self.evilSpeed = 1.65
                        self.oldSpeed = 1.65
                    }
                    
                    let actionMove = SKAction.moveTo(CGPoint(x: frame.midX, y: -evil.yScale/2), duration: NSTimeInterval(self.evilSpeed))
                    let actionMoveDone = SKAction.removeFromParent()
                    
                    evil.runAction(SKAction.sequence([actionMove, actionMoveDone]))
                }
                if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 3){
                    var randColor:Int = Int(arc4random_uniform(6))
                    var color = referenceColors[randColor]
                    let evil = SKSpriteNode(imageNamed: color)
                    var num = 0
                    
                    evil.position = CGPoint(x: frame.midX, y: size.height + evil.yScale/2)
                    evilCircles.append(color)
                    addChild(evil)
                    
                    evil.physicsBody = SKPhysicsBody(rectangleOfSize: evil.size)
                    evil.physicsBody!.dynamic = false
                    evil.physicsBody!.categoryBitMask = PhysicsCategory.Evil
                    evil.physicsBody!.contactTestBitMask = PhysicsCategory.Triangle
                    evil.physicsBody!.collisionBitMask = PhysicsCategory.None
                    num++
                    
                    if (self.score > 50) {
                        self.evilSpeed = 1.65
                        self.oldSpeed = 1.65
                    }
                    
                    let actionMove = SKAction.moveTo(CGPoint(x: frame.midX, y: -evil.yScale/2), duration: NSTimeInterval(self.evilSpeed))
                    let actionMoveDone = SKAction.removeFromParent()
                    
                    evil.runAction(SKAction.sequence([actionMove, actionMoveDone]))
                }
                if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 4){
                    var randColor:Int = Int(arc4random_uniform(6))
                    var color = referenceColors[randColor]
                    let evil = SKSpriteNode(imageNamed: color)
                    var num = 0
                    
                    evil.position = CGPoint(x: frame.midX, y: size.height + evil.yScale/2)
                    evilCircles.append(color)
                    addChild(evil)
                    
                    evil.physicsBody = SKPhysicsBody(rectangleOfSize: evil.size)
                    evil.physicsBody!.dynamic = false
                    evil.physicsBody!.categoryBitMask = PhysicsCategory.Evil
                    evil.physicsBody!.contactTestBitMask = PhysicsCategory.Triangle
                    evil.physicsBody!.collisionBitMask = PhysicsCategory.None
                    num++
                    if (self.score > 50) {
                        self.evilSpeed = 1.5
                        self.oldSpeed = 1.5
                    }
                    
                    if (self.score > 100) {
                        self.evilSpeed = 1.25
                        self.oldSpeed = 1.25
                    }
                    let actionMove = SKAction.moveTo(CGPoint(x: frame.midX, y: -evil.yScale/2), duration: NSTimeInterval(self.evilSpeed))
                    let actionMoveDone = SKAction.removeFromParent()
                    
                    evil.runAction(SKAction.sequence([actionMove, actionMoveDone]))
                }
                
                if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 5){
                    var randGroup:Int = Int(arc4random_uniform(6))
                    var randColor:Int = Int(arc4random_uniform(5))
                    var group:String = String(stringInterpolationSegment: referenceColors5[randGroup])
                    var color = referenceColors5[randGroup][randColor]
                    let evil = SKSpriteNode(imageNamed: color)
                    var num = 0
                    
                    evil.position = CGPoint(x: frame.midX, y: size.height + evil.yScale/2)
                    evilCircles.append(group)
                    addChild(evil)
                    
                    evil.physicsBody = SKPhysicsBody(rectangleOfSize: evil.size)
                    evil.physicsBody!.dynamic = false
                    evil.physicsBody!.categoryBitMask = PhysicsCategory.Evil
                    evil.physicsBody!.contactTestBitMask = PhysicsCategory.Triangle
                    evil.physicsBody!.collisionBitMask = PhysicsCategory.None
                    num++
                    
                    if (self.score > 50) {
                        self.evilSpeed = 1.75
                        self.oldSpeed = 1.75
                    }
                    
                    let actionMove = SKAction.moveTo(CGPoint(x: frame.midX, y: -evil.yScale/2), duration: NSTimeInterval(self.evilSpeed))
                    let actionMoveDone = SKAction.removeFromParent()
                    
                    evil.runAction(SKAction.sequence([actionMove, actionMoveDone]))
                }
                if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 6){
                    var randGroup:Int = Int(arc4random_uniform(6))
                    var randColor:Int = Int(arc4random_uniform(5))
                    var group:String = String(stringInterpolationSegment: referenceColors6[randGroup])
                    var color = referenceColors6[randGroup][randColor]
                    let evil = SKSpriteNode(imageNamed: color)
                    var num = 0
                    
                    evil.position = CGPoint(x: frame.midX, y: size.height + evil.yScale/2)
                    evilCircles.append(group)
                    addChild(evil)
                    
                    evil.physicsBody = SKPhysicsBody(rectangleOfSize: evil.size)
                    evil.physicsBody!.dynamic = false
                    evil.physicsBody!.categoryBitMask = PhysicsCategory.Evil
                    evil.physicsBody!.contactTestBitMask = PhysicsCategory.Triangle
                    evil.physicsBody!.collisionBitMask = PhysicsCategory.None
                    num++
                    if (self.score > 50) {
                        self.evilSpeed = 1.75
                        self.oldSpeed = 1.75
                    }
                    let actionMove = SKAction.moveTo(CGPoint(x: frame.midX, y: -evil.yScale/2), duration: NSTimeInterval(self.evilSpeed))
                    let actionMoveDone = SKAction.removeFromParent()
                    
                    evil.runAction(SKAction.sequence([actionMove, actionMoveDone]))
                }

            }
            else {
                self.view!.addSubview(self.pausedLabel)
                addChild(self.resumeButton)
                self.pauseGameButton.removeFromParent()
                self.runAction(SKAction.runBlock(self.pauseGame))
            }
        }//end func addEvil
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("isGamePaused") == false) {
            runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addEvil),SKAction.waitForDuration(1.0)])))
        }
    }//end func didMoveToView
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == "pauseGamePressed"){
            self.view!.addSubview(self.pausedLabel)
            addChild(self.resumeButton)
            self.pauseGameButton.removeFromParent()
            self.runAction(SKAction.runBlock(self.pauseGame))
        }
        if(touchedNode.name == "resumePressed") {
            resumeGame()
            self.resumeButton.removeFromParent()
            self.pausedLabel.removeFromSuperview()
            addChild(self.pauseGameButton)
        }
        if(touchedNode.name == "turnLeftName"){
            self.turnLeft()
        }
        if(touchedNode.name == "turnRightName"){
            self.turnRight()
        }
    }
    
    func pauseGame() {
        self.speed = 0
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isGamePaused")
    }
    
    func resumeGame() {
        self.speed = 1
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isGamePaused")
    }
    
    
    func turnRight() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isGamePaused") == false) {
            var firstColor = self.triangleColors[0]
            var pastColors = self.triangleColors
            
            self.triangleColors[0] = self.triangleColors[5]
            self.triangleColors[5] = self.triangleColors[4]
            self.triangleColors[4] = self.triangleColors[3]
            self.triangleColors[3] = self.triangleColors[2]
            self.triangleColors[2] = self.triangleColors[1]
            self.triangleColors[1] = firstColor
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 1){
                if (self.triangleColors[1] == "red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="yellow"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[3]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="blue"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[5]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 2){
                if (self.triangleColors[1] == "red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="yellow0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[3]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="blue0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[5]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 3){
                if (self.triangleColors[1] == "red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="yellow0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[3]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="blue0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[5]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 4){
                if (self.triangleColors[1] == "red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="yellow"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[3]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="blue"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[5]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 5){
                var firstColor5 = self.triangleColors5[0]
                var pastColors5 = self.triangleColors5
                
                self.triangleColors5[0] = self.triangleColors5[5]
                self.triangleColors5[5] = self.triangleColors5[4]
                self.triangleColors5[4] = self.triangleColors5[3]
                self.triangleColors5[3] = self.triangleColors5[2]
                self.triangleColors5[2] = self.triangleColors5[1]
                self.triangleColors5[1] = firstColor5
                if (self.triangleColors5[1] == ["red0orange","red0purple","red0green","red0blue","red0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[0]==["yellow0blue","yellow0red","yellow0green","yellow0purple","yellow0orange"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[3]==["red0orange","red0purple","red0green","red0blue","red0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[0]==["blue0green","blue0red","blue0yellow","blue0orange","blue0purple"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[5]==["red0orange","red0purple","red0green","red0blue","red0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[0]==["red0orange","red0purple","red0green","red0blue","red0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 6){
                var firstColor6 = self.triangleColors6[0]
                var pastColors6 = self.triangleColors6
                
                self.triangleColors6[0] = self.triangleColors6[5]
                self.triangleColors6[5] = self.triangleColors6[4]
                self.triangleColors6[4] = self.triangleColors6[3]
                self.triangleColors6[3] = self.triangleColors6[2]
                self.triangleColors6[2] = self.triangleColors6[1]
                self.triangleColors6[1] = firstColor6
                if (self.triangleColors6[1] == ["orange0red","purple0red","green0red","blue0red","yellow0red"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[0]==["blue0yellow","red0yellow","green0yellow","purple0yellow","orange0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[3]==["orange0red","purple0red","green0red","blue0red","yellow0red"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[0]==["green0blue","red0blue","yellow0blue","orange0blue","purple0blue"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[5]==["orange0red","purple0red","green0red","blue0red","yellow0red"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[0]==["orange0red","purple0red","green0red","blue0red","yellow0red"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[1]
                    self.trianglePositions[1] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[5]
                    self.trianglePositions[5] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
        }
    }//end turn right
    
    func turnLeft() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isGamePaused")==false) {
            var lastColor = self.triangleColors[0]
            var pastColors = self.triangleColors
            
            self.triangleColors[0] = self.triangleColors[1]
            self.triangleColors[1] = self.triangleColors[2]
            self.triangleColors[2] = self.triangleColors[3]
            self.triangleColors[3] = self.triangleColors[4]
            self.triangleColors[4] = self.triangleColors[5]
            self.triangleColors[5] = lastColor
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 1){
                if (self.triangleColors[1]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="yellow"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[3]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="blue"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[5]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 2){
                if (self.triangleColors[1]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="yellow0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[3]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="blue0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[5]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 3){
                if (self.triangleColors[1]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="yellow0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[3]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="blue0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[5]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="red0"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 4){
                if (self.triangleColors[1]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="yellow"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[3]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="blue"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[5]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors[0]=="red"){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }

            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 5){
                var lastColor5 = self.triangleColors5[0]
                var pastColors5 = self.triangleColors5
                
                self.triangleColors5[0] = self.triangleColors5[1]
                self.triangleColors5[1] = self.triangleColors5[2]
                self.triangleColors5[2] = self.triangleColors5[3]
                self.triangleColors5[3] = self.triangleColors5[4]
                self.triangleColors5[4] = self.triangleColors5[5]
                self.triangleColors5[5] = lastColor5
                if (self.triangleColors5[1]==["red0orange","red0purple","red0green","red0blue","red0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[0]==["yellow0blue","yellow0red","yellow0green","yellow0purple","yellow0orange"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[3]==["red0orange","red0purple","red0green","red0blue","red0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[0]==["blue0green","blue0red","blue0yellow","blue0orange","blue0purple"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[5]==["red0orange","red0purple","red0green","red0blue","red0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors5[0]==["red0orange","red0purple","red0green","red0blue","red0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
            if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 6){
                var lastColor6 = self.triangleColors6[0]
                var pastColors6 = self.triangleColors6
                
                self.triangleColors6[0] = self.triangleColors6[1]
                self.triangleColors6[1] = self.triangleColors6[2]
                self.triangleColors6[2] = self.triangleColors6[3]
                self.triangleColors6[3] = self.triangleColors6[4]
                self.triangleColors6[4] = self.triangleColors6[5]
                self.triangleColors6[5] = lastColor6
                if (self.triangleColors6[1]==["orange0red","purple0red","green0red","blue0red","yellow0red"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[0]==["blue0yellow","red0yellow","green0yellow","purple0yellow","orange0yellow"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[3]==["orange0red","purple0red","green0red","blue0red","yellow0red"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[0]==["green0blue","red0blue","yellow0blue","orange0blue","purple0blue"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[5]==["orange0red","purple0red","green0red","blue0red","yellow0red"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
                if (self.triangleColors6[0]==["orange0red","purple0red","green0red","blue0red","yellow0red"]){
                    var firstPosition = self.trianglePositions[0]
                    var pastTriangles = self.trianglePositions
                    
                    self.trianglePositions[0] = self.trianglePositions[5]
                    self.trianglePositions[5] = self.trianglePositions[4]
                    self.trianglePositions[4] = self.trianglePositions[3]
                    self.trianglePositions[3] = self.trianglePositions[2]
                    self.trianglePositions[2] = self.trianglePositions[1]
                    self.trianglePositions[1] = firstPosition
                    
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: pastTriangles[0]),SKTexture(imageNamed: self.trianglePositions[0])]
                    
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.1)
                    
                    self.mainTriangle.runAction(changeTriangle)
                }
            }
        }
    }//end turn left
    
    
    func evilDidCollideWithTriangle(evil:SKSpriteNode, mainTriangle:SKSpriteNode) {
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 1){
            if (evilCircles[0] == self.triangleColors[0]) {
                if(self.triangleColors[0] == "purple") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctPurple"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors[0] == "green") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctGreen"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors[0] == "orange") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctOrange"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                    
                }
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(correctSoundAction)
                }
                evil.removeFromParent()
                evilCircles.removeAtIndex(0)
                self.score++
                self.realScore.text = String(format: "Score: %i", self.score)
            }
            else {
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(loseSoundAction)
                }
                self.realScore.removeFromSuperview()
                
                NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "currentscore")
                
                if self.score > NSUserDefaults.standardUserDefaults().integerForKey("highscore1") {
                    NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "highscore1")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                let loseAction = SKAction.runBlock() {
                    let reveal = SKTransition.flipVerticalWithDuration(0.5)
                    let gameOverScene = GameOverScene(size: self.size)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                runAction(loseAction)
                
            }
            
        }
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 2){
            if (evilCircles[0] == self.triangleColors[0]) {
                if(self.triangleColors[0] == "purple0") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctPurple0"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors[0] == "green0") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctGreen0"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors[0] == "orange0") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctOrange0"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(correctSoundAction)
                }
                evil.removeFromParent()
                evilCircles.removeAtIndex(0)
                self.score++
                self.realScore.text = String(format: "Score: %i", self.score)
            }
            else {
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(loseSoundAction)
                }
                self.realScore.removeFromSuperview()
                
                NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "currentscore")
                
                if self.score > NSUserDefaults.standardUserDefaults().integerForKey("highscore2") {
                    NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "highscore2")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                let loseAction = SKAction.runBlock() {
                    let reveal = SKTransition.flipVerticalWithDuration(0.5)
                    let gameOverScene = GameOverScene(size: self.size)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                runAction(loseAction)
                
            }
            
        }
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 3){
            if (evilCircles[0] == self.triangleColors[0]) {
                if(self.triangleColors[0] == "purple0") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctPurple"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors[0] == "green0") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctGreen"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors[0] == "orange0") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctOrange"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                    
                }
                
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(correctSoundAction)
                }
                evil.removeFromParent()
                evilCircles.removeAtIndex(0)
                self.score++
                self.realScore.text = String(format: "Score: %i", self.score)
            }
            else {
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(loseSoundAction)
                }
                self.realScore.removeFromSuperview()
                
                NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "currentscore")
                
                if self.score > NSUserDefaults.standardUserDefaults().integerForKey("highscore3") {
                    NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "highscore3")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                let loseAction = SKAction.runBlock() {
                    let reveal = SKTransition.flipVerticalWithDuration(0.5)
                    let gameOverScene = GameOverScene(size: self.size)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                runAction(loseAction)
                
            }
            
        }
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 4){
            if (evilCircles[0] == self.triangleColors[0]) {
                if(self.triangleColors[0] == "purple") {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctPurple0"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                    if(self.triangleColors[0] == "green") {
                        var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctGreen0"),SKTexture(imageNamed: self.trianglePositions[0])]
                        var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                        self.mainTriangle.runAction(changeTriangle)
                    }
                    if(self.triangleColors[0] == "orange") {
                        var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctOrange0"),SKTexture(imageNamed: self.trianglePositions[0])]
                        var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                        self.mainTriangle.runAction(changeTriangle)
                        
                    }
                }
                
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(correctSoundAction)
                }
                evil.removeFromParent()
                evilCircles.removeAtIndex(0)
                self.score++
                self.realScore.text = String(format: "Score: %i", self.score)
            }
            else {
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(loseSoundAction)
                }
                self.realScore.removeFromSuperview()
                
                NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "currentscore")
                
                if self.score > NSUserDefaults.standardUserDefaults().integerForKey("highscore4") {
                    NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "highscore4")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                let loseAction = SKAction.runBlock() {
                    let reveal = SKTransition.flipVerticalWithDuration(0.5)
                    let gameOverScene = GameOverScene(size: self.size)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                runAction(loseAction)
            }
        }
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 5){
            if (evilCircles[0] == String(stringInterpolationSegment: self.triangleColors5[0])){
                if(self.triangleColors5[0] == ["purple0red", "purple0orange", "purple0green", "purple0blue", "purple0yellow"]) {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctPurple"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors5[0] == ["green0red","green0blue","green0purple","green0yellow","green0orange"]) {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctGreen"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors5[0] == ["orange0red","orange0blue","orange0purple","orange0green","orange0yellow"]) {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctOrange"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
            
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(correctSoundAction)
                }
                evil.removeFromParent()
                evilCircles.removeAtIndex(0)
                self.score++
                self.realScore.text = String(format: "Score: %i", self.score)
            }
            else {
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(loseSoundAction)
                }
                self.realScore.removeFromSuperview()
                
                NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "currentscore")
                
                if self.score > NSUserDefaults.standardUserDefaults().integerForKey("highscore5") {
                    NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "highscore5")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
               
                let loseAction = SKAction.runBlock() {
                    let reveal = SKTransition.flipVerticalWithDuration(0.5)
                    let gameOverScene = GameOverScene(size: self.size)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                runAction(loseAction)
            }
        }
            
        if(NSUserDefaults.standardUserDefaults().integerForKey("gamemode") == 6){
            if (evilCircles[0] == String(stringInterpolationSegment: self.triangleColors6[0])){
                if(self.triangleColors6[0] == ["red0purple", "orange0purple", "green0purple", "blue0purple", "yellow0purple"]) {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctPurple0"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors6[0] ==  ["red0green","blue0green","purple0green","yellow0green","orange0green"]) {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctGreen0"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                if(self.triangleColors6[0] == ["red0orange","blue0orange","purple0orange","green0orange","yellow0orange"]) {
                    var trianglePosition:[SKTexture] = [SKTexture(imageNamed: self.trianglePositions[0]),SKTexture(imageNamed: "correctOrange0"),SKTexture(imageNamed: self.trianglePositions[0])]
                    var changeTriangle = SKAction.animateWithTextures(trianglePosition, timePerFrame: 0.15)
                    self.mainTriangle.runAction(changeTriangle)
                }
                
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(correctSoundAction)
                }
                evil.removeFromParent()
                evilCircles.removeAtIndex(0)
                self.score++
                self.realScore.text = String(format: "Score: %i", self.score)
            }
            else {
                if(NSUserDefaults.standardUserDefaults().boolForKey("muted") == false) {
                    runAction(loseSoundAction)
                }
                self.realScore.removeFromSuperview()
                
                NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "currentscore")
                
                if self.score > NSUserDefaults.standardUserDefaults().integerForKey("highscore6") {
                    NSUserDefaults.standardUserDefaults().setInteger(self.score, forKey: "highscore6")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                
                let loseAction = SKAction.runBlock() {
                    let reveal = SKTransition.flipVerticalWithDuration(0.5)
                    let gameOverScene = GameOverScene(size: self.size)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                runAction(loseAction)
            }
        }
    }//end func evilDidCollideWithTriangle
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Evil != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Triangle != 0)) {
                evilDidCollideWithTriangle(firstBody.node as! SKSpriteNode, mainTriangle: secondBody.node as! SKSpriteNode)
        }
        
    }//end func didBeginContact
    
    func setUpAudio() {
        correctSoundAction = SKAction.playSoundFileNamed("correct.mp3", waitForCompletion: false)
        loseSoundAction = SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false)
    }
    
}//end class
