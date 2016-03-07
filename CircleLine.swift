//
//  CircleLine.swift
//  SuperAA
//
//  Created by Bashir on 2015-03-27.
//  Copyright (c) 2015 b26. All rights reserved.
//



/*

You cannot add the same node twice. Each node must be different. 

The circle will always be the same, but the number of lines will always be different

The struct will look something like this: Circle(numberOfLines: 2, speed: 1)



*/
import Foundation
import SpriteKit


struct CircleLine {
    var circleLine: SKSpriteNode
    
    init(circleLine: SKSpriteNode) {
        self.circleLine = circleLine
    }
    
}
