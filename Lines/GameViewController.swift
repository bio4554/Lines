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
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate {
    
    var viewController: GameViewController!
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MainMenu(size: CGSize(width: 1536, height: 2048))
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsPhysics = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        bannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-6771136112977262/5909802439"
        
        let reqad = GADRequest()
        bannerView.load(reqad)
        self.view.addSubview(bannerView)
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
