//
//  AboutScene.swift
//  gravity
//
//  Created by bio4554 on 2/17/17.
//  Copyright © 2017 Austin Childress. All rights reserved.
//

import GameplayKit
import SceneKit

class AboutScene: SKScene {
    override func didMove(to view: SKView) {
        let paragraph = SKLabelNode()
        let testers = SKLabelNode()
        paragraph.text = "Made by AC"
        testers.text = "Tested by HH, BL, JD, JL"
        paragraph.fontSize = 200
        testers.fontSize = 200
        paragraph.position = CGPoint(x: size.width/2, y: size.height/2+200)
        testers.position = CGPoint(x: size.width/2, y: size.height/2-200)
        addChild(paragraph)
        addChild(testers)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
        }
    }
}
