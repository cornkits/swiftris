//
//  GameViewController.swift
//  Swiftris
//
//  Created by Dave Sims on 4/12/16.
//  Copyright (c) 2016 Walker Sims. All rights reserved.
//

var scene: GameScene!


import UIKit
import SpriteKit

 class GameViewController: UIViewController, SwiftrisDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func didTick() {
            // #15
            swiftris.letShapeFall()
            swiftris.fallingShape?.lowerShapeByOneRow()
            scene.redrawShape(swiftris.fallingShape!, completion: {})
        }
        
        func nextShape() {
            let newShapes = swiftris.newShape()
            guard let fallingShape = newShapes.fallingShape else {
                return
            }
            self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
            self.scene.movePreviewShape(fallingShape) {
                // #16
                self.view.userInteractionEnabled = true
                self.scene.startTicking()
            }
        }
        
        @IBAction func didPan(sender: UIPanGestureRecognizer) {
            // #2
            swiftris.dropShape()
        }
        
        // #5
        func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        // #6
        func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer is UISwipeGestureRecognizer {
                if otherGestureRecognizer is UIPanGestureRecognizer {
                    return true
                }
            } else if gestureRecognizer is UIPanGestureRecognizer {
                if otherGestureRecognizer is UITapGestureRecognizer {
                    return true
                }
            }
            return false
        }
            let currentPoint = sender.translationInView(self.view)
            if let originalPoint = panPointReference {
                // #3
                if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                    // #4
                    if sender.velocityInView(self.view).x > CGFloat(0) {
                        swiftris.moveShapeRight()
                        panPointReference = currentPoint
                    } else {
                        swiftris.moveShapeLeft()
                        panPointReference = currentPoint
                    }
                }
            } else if sender.state == .Began {
                panPointReference = currentPoint
            }
        
        func gameDidBegin(swiftris: Swiftris) {
            levelLabel.text = "\(swiftris.level)"
            scoreLabel.text = "\(swiftris.score)"
            scene.tickLengthMillis = TickLengthLevelOne
            // The following is false when restarting a new game
            if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
                scene.addPreviewShapeToScene(swiftris.nextShape!) {
                    self.nextShape()
                }
            } else {
                nextShape()
            }
        }
        
        func gameDidEnd(swiftris: Swiftris) {
            view.userInteractionEnabled = false
            scene.stopTicking()
            scene.playSound("Sounds/gameover.mp3")
            scene.animateCollapsingLines(swiftris.removeAllBlocks(), fallenBlocks: swiftris.removeAllBlocks()) {
                swiftris.beginGame()

        }
        
        func gameDidLevelUp(swiftris: Swiftris) {
            
            levelLabel.text = "\(swiftris.level)"
            if scene.tickLengthMillis >= 100 {
                scene.tickLengthMillis -= 100
            } else if scene.tickLengthMillis > 50 {
                scene.tickLengthMillis -= 50
            }
            scene.playSound("Sounds/levelup.mp3")
            
        }
        
        func gameShapeDidDrop(swiftris: Swiftris) {
            
        }
        
        func gameShapeDidLand(swiftris: Swiftris) {
            scene.stopTicking()
            nextShape()
        }
        
        // #17
        func gameShapeDidMove(swiftris: Swiftris) {
            scene.redrawShape(swiftris.fallingShape!) {}
        }
            
            // Configure the view.
            let skView = view as! SKView
            skView.multipleTouchEnabled = false
            
            // Create and configure the scene.
            scene = GameScene(size: skView.bounds.size)
            scene.scaleMode = .AspectFill
            scene.tick = didTick
            
            swiftris = Swiftris()
            swiftris.delegate = self
            swiftris.beginGame()
            
            // Present the scene.
            skView.presentScene(scene)
        
        //configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        //create and configure the scene
        scene = GameScene (size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        //present the scene
        skView.presentScene(scene)
            var panPointReference:CGPoint?
    }
}
