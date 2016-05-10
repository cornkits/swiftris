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

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure the view
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        //create and configure the scene
        scene = GameScene (size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        //present the scene
        skView.presentScene(scene)
    }
}
