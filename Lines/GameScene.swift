//
//  GameScene.swift
//  Lines
//
//  Created by Austin Childress on 2/6/17.
//  Copyright © 2017 Austin Childress. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var startingPoint:Int = 300
    var blocks:[SKShapeNode] = []
    var currentBlock = 0
    var left = true
    
    
    override func didMove(to view: SKView) {
        
        
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        let ledge = SKNode()
        ledge.position = CGPoint(x: size.width/2, y: 100)
        let ledgeBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 10))
        ledgeBody.isDynamic = false
        ledge.physicsBody = ledgeBody
        addChild(ledge)
        addBlock()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            
            self.touchDown(atPoint: t.location(in: self))
        
        }
        let blockBody = SKPhysicsBody(rectangleOf: CGSize(width: 400, height: 100))
        blockBody.mass = 5
        blocks[currentBlock].removeAllActions()
        blocks[currentBlock].physicsBody = blockBody
        currentBlock += 1
        addBlock()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func addBlock() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 100))
        path.addLine(to: CGPoint(x: -200, y: 100))
        path.addLine(to: CGPoint(x: -200, y: 0))
        
        let section = SKShapeNode(path: path.cgPath)
        section.position = CGPoint(x: size.width/2, y: CGFloat(startingPoint))
        section.fillColor = .red
        section.strokeColor = .red
        blocks.append(section)
        addChild(blocks[currentBlock])
        
        let moveLeft = SKAction.move(to: CGPoint(x: size.width/2-200, y:  CGFloat(startingPoint)), duration: 1)
        let moveRight = SKAction.move(to: CGPoint(x: size.width/2+200, y:  CGFloat(startingPoint)), duration: 1)
        if left {
            blocks[currentBlock].run(SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight])))
            left = false
        }
        else {
            blocks[currentBlock].run(SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft])))
            left = true
        }
        startingPoint += 100
    }
}
