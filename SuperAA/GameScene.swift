//
//  GameScene.swift
//  SuperAA
//
//  Created by Bashir on 2015-03-27.
//  Copyright (c) 2015 b26. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameOver = 0
    
    var score = 0
    
    enum ColliderType:UInt32 {
        
        case bigCircle = 1
        case smallCircle = 2
        case impactCircle = 4
        
    }
    
    var smallCircle = SKShapeNode(circleOfRadius: 10)
    
    var line_ = SKSpriteNode()
    
    var laterBaby = SKSpriteNode()
    
    var impactCircle = SKShapeNode(circleOfRadius: 10)
    
    var circle = SKShapeNode(circleOfRadius: 100)
    
    var radius:CGFloat = 10.0
    

    var bigCircle = SKSpriteNode()
    var circleHolder = SKSpriteNode()
    var impactCircleHolder = SKSpriteNode()
    var retryHolder = SKSpriteNode()
    var scoreLabelHolder = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    
    override init(size: CGSize) {
        super.init(size: size)

        let worldBorder = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = worldBorder
        self.physicsBody?.friction = 0
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.name = "Self"
        self.addChild(circleHolder)
        self.addChild(impactCircleHolder)
        self.addChild(retryHolder)
        self.addChild(scoreLabelHolder)
        loadCircle(amountOfLines: 2)
        createImpactCircle()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            
            var location:CGPoint = touch.locationInNode(self)
            var node:SKNode = self.nodeAtPoint(location)
            
            
            if let name = node.name as String! {
                if node.name == "retry" {
                    println("retry works")
                    resetGame()
                }
                    
                else if node.name == "quit" {
                    println("quit works")
                    loadStart()
                }
                else {
                    println("touchesBegan node.name \(name)")
                }
            }
            else if self.gameOver == 0 {
                impactCircle.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
            }
            
            else {
                println("This is being called from touchesBegan")
            }
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func loadCircle (#amountOfLines: Double) {
        
        circle.physicsBody = SKPhysicsBody(circleOfRadius: 95)
        circle.physicsBody?.dynamic = false
        circle.name = "Big Circle"
        circle.physicsBody?.categoryBitMask = ColliderType.bigCircle.rawValue
        circle.physicsBody?.contactTestBitMask = ColliderType.impactCircle.rawValue
        circle.physicsBody?.collisionBitMask = ColliderType.impactCircle.rawValue
        circle.physicsBody?.usesPreciseCollisionDetection = true
        circle.fillColor = UIColor.whiteColor()
        
        scoreLabel = SKLabelNode(text: "\(score)")
        
        scoreLabel.fontSize = 60
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontColor = UIColor.darkGrayColor()
        
        scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - scoreLabel.frame.width/2)
        
        scoreLabel.zPosition = 10
        

        
        circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        var rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        
        var forever = SKAction.repeatActionForever(rotate)
        
   
        
        
        for var i:Double = 0; i < amountOfLines; i++ {
            
            var smallCircle = SKShapeNode(circleOfRadius: 10)
            smallCircle.name = "Small Circle"
            smallCircle.physicsBody = SKPhysicsBody(circleOfRadius: 10)
            smallCircle.physicsBody?.dynamic = false
            smallCircle.physicsBody?.categoryBitMask =  ColliderType.smallCircle.rawValue
            smallCircle.physicsBody?.contactTestBitMask = ColliderType.impactCircle.rawValue
            smallCircle.physicsBody?.collisionBitMask = ColliderType.impactCircle.rawValue
            smallCircle.physicsBody?.usesPreciseCollisionDetection = true
            
            var line_ = SKSpriteNode()
            
            smallCircle.fillColor = UIColor.whiteColor()
            
            smallCircle.strokeColor = UIColor.whiteColor()
            
            line_ = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(150, 2))
            
            line_.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(150, 2))
            
            line_.physicsBody?.categoryBitMask = ColliderType.smallCircle.rawValue
            line_.physicsBody?.contactTestBitMask = ColliderType.smallCircle.rawValue
            line_.physicsBody?.collisionBitMask = ColliderType.impactCircle.rawValue
            line_.physicsBody?.dynamic = false
            
            line_.anchorPoint = CGPointMake(0,0)
            
            smallCircle.position = CGPoint(x:line_.size.width, y: 0)
            
            var angle = CGFloat(DegreesToRadians(45 * i))

            
//            if i == 0 {
//                angle = CGFloat(DegreesToRadians(0))
//            }
//            
//            if i == 1 {
//                angle = CGFloat(DegreesToRadians(90))
//
//            }
//            
//            if i == 2 {
//                angle = CGFloat(DegreesToRadians(180))
//
//            }
//            
//            if i == 3 {
//                angle = CGFloat(DegreesToRadians(270))
//
//            }

            var rotateLine = SKAction.rotateByAngle(angle, duration: 0)

            line_.runAction(rotateLine)
            
            line_.addChild(smallCircle)
            
            circle.addChild(line_)
            
        }
                
        circle.runAction(forever)
        
        scoreLabelHolder.addChild(scoreLabel)
        circleHolder.addChild(circle)
        
    }
    
    func DegreesToRadians (value:Double) -> Double {
        return value * M_PI / 180.0
    }
    
    func randomPointOnCircle(radius:Float, center:CGPoint) -> CGPoint {
        let theta = Float(arc4random_uniform(UInt32.max))/Float(UInt32.max) * Float(M_PI) * 2.0
        let x = radius * cosf(theta)
        let y = radius * sinf(theta)
        return CGPointMake(CGFloat(x)+center.x,CGFloat(y)+center.y)
    }
    
    func createImpactCircle () {
        //impactCircleHolder = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(radius * 2, radius * 2))
        //impactCircleHolder.position = CGPoint(x: CGRectGetMidX(self.frame), y: 100)
        //impactCircleHolder.zPosition = 2
        //var bodyPath:CGPathRef = CGPathCreateWithEllipseInRect(CGRectMake(-impactCircleHolder.size.width/2, -impactCircleHolder.size.height/2, impactCircleHolder.size.width, impactCircleHolder.size.height), nil)
        impactCircle.fillColor = UIColor.whiteColor()
        impactCircle.name = "Impact Circle"
        impactCircle.strokeColor = UIColor.whiteColor()
        impactCircle.lineWidth = 0
        impactCircle.position = CGPointMake(CGRectGetMidX(self.frame), 100)
        impactCircle.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        //impactCircle.path = bodyPath
        impactCircle.physicsBody?.categoryBitMask = ColliderType.impactCircle.rawValue
        impactCircle.physicsBody?.contactTestBitMask = ColliderType.bigCircle.rawValue
        impactCircle.physicsBody?.dynamic = true
        impactCircle.physicsBody?.affectedByGravity = false
        impactCircle.physicsBody?.restitution = 0.0
        impactCircle.physicsBody?.usesPreciseCollisionDetection = true
        //self.addChild(impactCircleHolder)
        impactCircleHolder.addChild(impactCircle)
        //CGPathRelease(bodyPath)
    }
    
    
    func spinCircle () {
        
        var rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        
        var forever = SKAction.repeatActionForever(rotate)
        
        circleHolder.size = CGSizeMake(10, 10)
        
        circleHolder.anchorPoint = CGPointMake(0.5, 0.5)
        
        circleHolder.runAction(forever)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if self.gameOver == 0 {
        
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
            
            if firstBody.categoryBitMask == secondBody.contactTestBitMask{
                impactCircleHolder.removeAllChildren()
                
                var line_ = SKSpriteNode()
                line_ = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(2, 65))
                
                line_.position = CGPoint(x: secondBody.node!.position.x, y: secondBody.node!.position.y + secondBody.node!.frame.height/2)

                line_.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(2, 65))
                line_.physicsBody?.dynamic = false
                line_.physicsBody?.categoryBitMask = ColliderType.smallCircle.rawValue
                line_.physicsBody?.contactTestBitMask = ColliderType.impactCircle.rawValue
                line_.physicsBody?.collisionBitMask = ColliderType.impactCircle.rawValue
                
                var smallCircleTwo = SKShapeNode(circleOfRadius: 10)
                smallCircleTwo.position = CGPoint(x: CGRectGetMidX(line_.frame), y: CGRectGetMidY(line_.frame) - line_.frame.height/2)
                smallCircleTwo.physicsBody = SKPhysicsBody(circleOfRadius: 10)
                smallCircleTwo.physicsBody?.dynamic = false
                smallCircleTwo.physicsBody?.affectedByGravity = false
                smallCircleTwo.physicsBody?.categoryBitMask = ColliderType.smallCircle.rawValue
                smallCircleTwo.physicsBody?.contactTestBitMask = ColliderType.impactCircle.rawValue
                smallCircleTwo.physicsBody?.collisionBitMask = ColliderType.impactCircle.rawValue
                smallCircleTwo.physicsBody?.usesPreciseCollisionDetection = true
                smallCircleTwo.fillColor = UIColor.whiteColor()
                smallCircleTwo.strokeColor = UIColor.whiteColor()
                smallCircleTwo.name = "Smaller Circle"
                
                line_.addChild(smallCircleTwo)
                circle.addChild(line_)
                
                score++
                scoreLabel.text = "\(score)"
                createImpactCircle()
   
        
            }
            
            else if firstBody.categoryBitMask == ColliderType.smallCircle.rawValue && secondBody.categoryBitMask == ColliderType.impactCircle.rawValue
                {
                
                if firstBody.node?.name == nil || secondBody.node?.name == nil {
                    println("firstBody and secondBody are showing NIL")
                }
                else {
                    self.gameOver = 1
                    circle.speed = 0
                    impactCircle.speed = 0
                    impactCircle.physicsBody?.resting = true
                    
                    retryLabel()
                }

            }
            
            else {
            
                println("This will automatically get in here if gameOver == 1")
            }
            
        }
        
    }
    
    func retryLabel () {
        if self.gameOver == 1 {
            var retryLabel = SKLabelNode(text: "Retry")
            retryLabel.position = CGPointMake(CGRectGetMidX(self.frame), 80)
            retryLabel.fontSize = 60
            retryLabel.fontColor = UIColor.whiteColor()
            retryLabel.name = "retry"
            
            var quitLabel = SKLabelNode(text: "Quit")
            quitLabel.position = CGPointMake(CGRectGetMidX(self.frame), 40)
            quitLabel.fontSize = 30
            quitLabel.fontColor = UIColor.whiteColor()
            quitLabel.name = "quit"
            
            retryHolder.addChild(retryLabel)
            retryHolder.addChild(quitLabel)
        }
        else {
            println("The retry label is being created while gameOver == 0 ")
        }
    }
    
    func resetGame () {
        impactCircleHolder.removeAllChildren()
        retryHolder.removeAllChildren()
        circleHolder.removeAllChildren()
        circle.removeAllChildren()
        circle.removeAllActions()
        line_.removeAllChildren()
        scoreLabelHolder.removeAllChildren()
        loadCircle(amountOfLines: 0)
        createImpactCircle()
        score = 0
        scoreLabel.text = "0"
        circle.speed = 1
        self.gameOver = 0
        println(circle.speed)
        
    }
    
    func joinPhysicsBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody, point:CGPoint) {
        let joint = SKPhysicsJointFixed.jointWithBodyA(bodyA, bodyB: bodyB, anchor: point)
        println(bodyA.node?.name)
        println(bodyB.node?.name)
        self.physicsWorld.addJoint(joint)
    }
    
    func loadStart () {
        let skView = self.view as SKView!
        
        if skView.scene != nil {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            
            let scene = StartScreen(size: skView.bounds.size)
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
    }
}
