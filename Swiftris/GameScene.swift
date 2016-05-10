//
//  GameScene.swift
//  Swiftris
//
//  Created by Dave Sims on 4/12/16.
//  Copyright (c) 2016 Walker Sims. All rights reserved.
//

import SpriteKit


let BlockSize:CGFloat = 20.0

let TickLengthLevelOne = NSTimeInterval(600)

class GameScene: SKScene {
    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    required init (coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init (size: CGSize) {
        super.init (size: size )
        
        anchorPoint = CGPoint (x:0, y: 1.0)
        
        let background = SKSpriteNode (imageNamed: "background")
        background.position = CGPoint (x:0, y:0)
        background.anchorPoint = CGPoint (x: 0, y: 1.0)
        addChild (background)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        guard let lastTick = lastTick else {
            return
        }
        let timePassed = lastTick.timeIntervalSinceNow * -1000.0
        if timePassed > tickLengthMillis {
            self.lastTick = NSDate()
            tick?()
        }
    }
    
    func startTicking() {
        lastTick = NSDate()
    }
    
    func stopTicking() {
        lastTick = nil
    }
}
