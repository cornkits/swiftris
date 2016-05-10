//
//  GameScene.swift
//  Swiftris
//
//  Created by Dave Sims on 4/12/16.
//  Copyright (c) 2016 Walker Sims. All rights reserved.
//

import SpriteKit

// #1
func animateCollapsingLines(linesToRemove: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>, completion:() -> ()) {
    var longestDuration: NSTimeInterval = 0
    // #2
    for (columnIdx, column) in fallenBlocks.enumerate() {
        for (blockIdx, block) in column.enumerate() {
            let newPosition = pointForColumn(block.column, row: block.row)
            let sprite = block.sprite!
            // #3
            let delay = (NSTimeInterval(columnIdx) * 0.05) + (NSTimeInterval(blockIdx) * 0.05)
            let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
            let moveAction = SKAction.moveTo(newPosition, duration: duration)
            moveAction.timingMode = .EaseOut
            sprite.runAction(
                SKAction.sequence([
                    SKAction.waitForDuration(delay),
                    moveAction]))
            longestDuration = max(longestDuration, duration + delay)
        }
    }
    
    for rowToRemove in linesToRemove {
        for block in rowToRemove {
            // #4
            let randomRadius = CGFloat(UInt(arc4random_uniform(400) + 100))
            let goLeft = arc4random_uniform(100) % 2 == 0
            
            var point = pointForColumn(block.column, row: block.row)
            point = CGPointMake(point.x + (goLeft ? -randomRadius : randomRadius), point.y)
            
            let randomDuration = NSTimeInterval(arc4random_uniform(2)) + 0.5
            // #5
            var startAngle = CGFloat(M_PI)
            var endAngle = startAngle * 2
            if goLeft {
                endAngle = startAngle
                startAngle = 0
            }
            let archPath = UIBezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
            let archAction = SKAction.followPath(archPath.CGPath, asOffset: false, orientToPath: true, duration: randomDuration)
            archAction.timingMode = .EaseIn
            let sprite = block.sprite!
            // #6
            sprite.zPosition = 100
            sprite.runAction(
                SKAction.sequence(
                    [SKAction.group([archAction, SKAction.fadeOutWithDuration(NSTimeInterval(randomDuration))]),
                        SKAction.removeFromParent()]))
        }
    }
    // #7
    runAction(SKAction.waitForDuration(longestDuration), completion:completion)
}


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
            runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("Sounds/theme.mp3", waitForCompletion: true)))
        }
        
        // #9
        func playSound(sound:String) {
            runAction(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
        }
        }
    }
    
    func startTicking() {
        lastTick = NSDate()
    }
    
    func stopTicking() {
        lastTick = nil
    }
}
