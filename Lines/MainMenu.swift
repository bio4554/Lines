//
//  MainMenu.swift
//  Lines
//
//  Created by Austin Childress on 2/7/17.
//  Copyright © 2017 Austin Childress. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenu: SKScene {
    var buttonShape = SKShapeNode()
    override func didMove(to view: SKView) {
        let text = SKLabelNode()
        text.text = "tap game thing"
        text.fontSize = 150
        text.position = CGPoint(x: size.width/2, y: size.height/2)
        
        buttonShape = SKShapeNode(rectOf: CGSize(width: 500, height: 200))
        buttonShape.fillColor = .white
        buttonShape.position = CGPoint(x: size.width/2, y: size.height/3+25)
        
        let goText = SKLabelNode()
        goText.text = "go"
        goText.fontSize = 150
        goText.fontColor = .black
        goText.position = CGPoint(x: size.width/2, y: size.height/3)
        
        addChild(buttonShape)
        addChild(text)
        addChild(goText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if buttonShape.contains(t.location(in: self)) {
                let trans = SKTransition.reveal(with: .left, duration: 0.5)
                
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition:trans)
            }
        }
    }
}
