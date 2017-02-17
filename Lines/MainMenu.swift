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
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        let text = SKLabelNode()
        text.text = "gra_vity"
        text.fontSize = 200
        text.position = CGPoint(x: size.width/2, y: size.height/2)
        
       
        
        let goText = SKLabelNode()
        goText.text = "∨"
        goText.fontSize = 500
        goText.fontColor = .white
        goText.position = CGPoint(x: size.width/2, y: size.height/4)
        
        let versionText = SKLabelNode()
        versionText.text = "v1.2 BETA"
        versionText.fontSize = 75
        versionText.fontName = "AvenirNext-Bold"
        versionText.position = CGPoint(x: size.width/2, y: 100)
        
        addChild(text)
        addChild(goText)
        addChild(versionText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
                let trans = SKTransition.reveal(with: .down, duration: 0.5)
                
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition:trans)
            
        }
    }
}
