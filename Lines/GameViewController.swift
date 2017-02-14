//
//  GameViewController.swift
//  Lines
//
//  Created by Austin Childress on 2/6/17.
//  Copyright © 2017 Austin Childress. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenu(size: CGSize(width: 1536, height: 2048))
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsPhysics = false
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
