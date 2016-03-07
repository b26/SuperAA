//
//  StartScreen.swift
//  SuperAA
//
//  Created by Bashir on 2015-04-01.
//  Copyright (c) 2015 b26. All rights reserved.
//

import UIKit
import SpriteKit

class StartScreen: SKScene {

//Start Init
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
//End
    
    var labelHolder = SKSpriteNode()

    
    
    override func didMoveToView(view: SKView) {
        self.addChild(labelHolder)
        showStartLabel()
        println("I'm here")
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            println("touch")
            loadGame()
        }
    }
    
    func showStartLabel() {
        var startLabel = SKLabelNode(text: "Start")
        startLabel.fontSize = 60
        startLabel.fontColor = UIColor.whiteColor()
        startLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        startLabel.name = "StartLabel"
        labelHolder.addChild(startLabel)
    }
    
    func loadGame () {
        let skView = self.view as SKView!
        
        if skView.scene != nil {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            
            let scene = GameScene(size: skView.bounds.size)
            scene.scaleMode = .AspectFit
            
            skView.presentScene(scene)
        }
    }
}
