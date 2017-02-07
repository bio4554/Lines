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
    var startingPoint:Int = 150
    var blocks:[SKShapeNode] = []
    var currentBlock = 0
    var left = true
    var first = true
    var moveSpeed = 1.0
    var lost = false
    var won = false
    let cameraNode = SKCameraNode()
    var failureRect = SKShapeNode()
    let scoreText = SKLabelNode()
    var score = 0
    
    
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
        
        
        scoreText.text = String(score)
        scoreText.fontColor = .white
        scoreText.fontSize = 150
        scoreText.position = CGPoint(x: size.width/4, y: size.height/2+150)
        addChild(scoreText)
        
        failureRect = SKShapeNode(rectOf: CGSize(width: size.width, height: 10))
        failureRect.fillColor = .red
        failureRect.position = CGPoint(x: size.width/2, y: CGFloat(50))
        let failureBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 10))
        failureBody.categoryBitMask = 0
        failureBody.collisionBitMask = 0
        failureBody.contactTestBitMask = 1
        failureBody.isDynamic = false
        failureRect.physicsBody = failureBody
        
        
        
        addChild(failureRect)
        
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        physicsWorld.gravity.dy = -22
        physicsWorld.contactDelegate = self
        /*
        let ledge = SKNode()
        ledge.position = CGPoint(x: size.width/2, y: 100)
        let ledgeBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 10))
        ledgeBody.isDynamic = false
        ledge.physicsBody = ledgeBody
        addChild(ledge)
        */
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
        print("Tapped\n")
        if !lost {
            
            
        let blockBody = SKPhysicsBody(rectangleOf: CGSize(width: 400, height: 100))
        blockBody.mass = 5
        blockBody.contactTestBitMask = 0
        blockBody.categoryBitMask = 1
        if first {
            print("Is first")
            blockBody.isDynamic = false
            first = false
            blocks[currentBlock].removeAllActions()
            blocks[currentBlock].physicsBody = blockBody
            
            currentBlock += 1
            score += 1
            moveSpeed = moveSpeed - 0.01
            addBlock()
        } else {
            print("Is not first")
            print(currentBlock)
            
                print("Is not moving")
                blocks[currentBlock].removeAllActions()
                blocks[currentBlock].physicsBody = blockBody
                
                currentBlock += 1
                score += 1
                moveSpeed = moveSpeed - 0.01
                addBlock()
            
        }
            
        }
        
        
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
        
        if blocks[currentBlock].position.y > cameraNode.position.y && !cameraNode.hasActions(){
            cameraNode.position.y = cameraNode.position.y + 100
            failureRect.position.y += 100
        }
        
        if scoreText.position.y < cameraNode.position.y+150 && !cameraNode.hasActions() {
            scoreText.position.y += 100
        }
        
        if Int(scoreText.text!)! != score {
            scoreText.text = String(score)
        }
        
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
        section.fillColor = .green
        section.strokeColor = .green
        
        blocks.append(section)
        addChild(blocks[currentBlock])
        
        let moveLeft = SKAction.move(to: CGPoint(x: size.width/2-400, y:  CGFloat(startingPoint)), duration: moveSpeed)
        let moveRight = SKAction.move(to: CGPoint(x: size.width/2+400, y:  CGFloat(startingPoint)), duration: moveSpeed)
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
    
    func loser() {
        /*
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
        self.view?.presentScene(nil)
        */
        if !lost {
            
        let loser = SKLabelNode()
        loser.text = "YOU LOSE"
        loser.fontSize = 200
        loser.fontColor = SKColor.red
        loser.position = CGPoint(x: size.width/2, y: cameraNode.position.y+350)
        addChild(loser)
            lost = true
            
        }
    }
    
    func winner() {
        if !won {
            let winner = SKLabelNode()
            winner.text = "YOU WIN"
            winner.fontSize = 200
            winner.fontColor = SKColor.green
            winner.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(winner)
            lost = true
        }
    }
    
    func restart() {
        currentBlock = 0
        won = false
        lost = false
        
        
        blocks.removeAll(keepingCapacity: false)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode {
            print("TEST")
            print("CONTACT")
            print(nodeB.physicsBody?.velocity.dy)
            if (nodeB.physicsBody?.velocity.dy)! < CGFloat(-100.0){
                print("FAST")
                
                loser()
                
            }
        
        }
    }
}
