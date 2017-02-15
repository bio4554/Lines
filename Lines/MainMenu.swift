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
        text.text = "gravity"
        text.fontSize = 200
        text.position = CGPoint(x: size.width/2, y: size.height/2)
        
       
        
        let goText = SKLabelNode()
        goText.text = "∨"
        goText.fontSize = 500
        goText.fontColor = .white
        goText.position = CGPoint(x: size.width/2, y: size.height/4)
        
        addChild(text)
        addChild(goText)
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
