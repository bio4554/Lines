//
//  GameScene.swift
//  Lines
//
//  Created by Austin Childress on 2/6/17.
//  Copyright © 2017 Mars Dev. All rights reserved.
//

import SpriteKit
import GameplayKit
import GoogleMobileAds



class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let prefs = UserDefaults.standard
    
    var startingPoint:Int = 100
    var blocks:[SKShapeNode] = []
    var currentBlock = 0
    var left = false
    var first = true
    var moveSpeed = 1.0
    var lost = false
    var won = false
    let cameraNode = SKCameraNode()
    var failureRect = SKShapeNode()
    var failureRect2 = SKShapeNode()
    var failureRect3 = SKShapeNode()
    let scoreText = SKLabelNode()
    var score = 0
    var highScore = 0
    var buttonShape = SKShapeNode()
    var lostOnce = false
    var isFalling = false
    var loser = SKLabelNode()
    let highScoreText = SKLabelNode()
    var moveTo = Int()
    
    
    
    override func didMove(to view: SKView) {
        
        
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        self.backgroundColor = .black
        
        if let highScoret:Int = UserDefaults.standard.integer(forKey: "highScore") {
            highScore = highScoret
        }
        
        
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
        
        
        setupLedges()
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
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if !lost {
            for t in touches {
                
                self.touchDown(atPoint: t.location(in: self))
                let node = nodes(at: t.location(in: self))
                if buttonShape.contains(t.location(in: self)) && lost {
                    
                    self.restart()
                }
                
            }
            print("Tapped\n")
            if !lost && Int((blocks[currentBlock].position.y)) == moveTo {
                //if !lost {
                
                let blockBody = SKPhysicsBody(polygonFrom: blocks[currentBlock].path!)
                
                blockBody.mass = 500
                blockBody.friction = 500.0
                blockBody.contactTestBitMask = 0
                blockBody.categoryBitMask = 1
                blockBody.restitution = 0
                
                
                if first {
                    print("Is first")
                    blockBody.isDynamic = false
                    first = false
                    blocks[currentBlock].removeAllActions()
                    blocks[currentBlock].physicsBody = blockBody
                    
                    currentBlock += 1
                    score += 1
                    moveSpeed = moveSpeed - 0.01
                    startingPoint += 500
                    addBlock()
                } else {
                    print("Is not first")
                    print(currentBlock)
                    
                    print("Is not moving")
                    blocks[currentBlock].removeAllActions()
                    blocks[currentBlock].physicsBody = blockBody
                    
                    print("X: ", blocks[currentBlock].position.x, "\nX2: ", blocks[0].position.x)
                    if blocks[currentBlock].position.x > blocks[0].position.x-10 && blocks[currentBlock].position.x < blocks[0].position.x+10 {
                        blocks[currentBlock].fillColor = .green
                        blocks[currentBlock].strokeColor = .green
                        score += 2
                    } else {
                        score += 1
                    }
                    
                    
                    currentBlock += 1
                    moveSpeed = moveSpeed - 0.01
                    addBlock()
                    
                }
                
            } else {
                print("Not at startingPoint! at: ", Int((blocks[currentBlock].position.y)), ", should be at: ", moveTo)
            }
            
        } else {
            restart()
            //cleanBlocks()
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
        
        if (blocks[lastBlock()].position.y > cameraNode.position.y-200 || blocks[lastBlock()].position.y > cameraNode.position.y) && !cameraNode.hasActions() && !first && !lost {
            moveScreen()
            
            //TODO Fix this shit
            //failureRect.position.y += 100
        }
        
        /*if scoreText.position.y < cameraNode.position.y+150 && !cameraNode.hasActions() {
         moveScreen()
         }*/
        
        if Int(scoreText.text!)! != score {
            scoreText.text = String(score)
        }
        
        if isFalling {
            print("FALLING AT ", (blocks.last?.position.y)!)
            if (blocks.last?.position.y)! < CGFloat(-500) {
                isFalling = false
                moveLostElements()
                //restart()
            }
        }
        
    }
    
    func lastBlock() -> Int {
        if currentBlock == 0 {
            return currentBlock
        } else {
            return currentBlock - 1
        }
    }
    
    func addBlock() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 100))
        path.addLine(to: CGPoint(x: -200, y: 100))
        path.addLine(to: CGPoint(x: -200, y: 0))
        
        print("High score: ", highScore)
        
        let section = SKShapeNode(path: path.cgPath)
        section.position = CGPoint(x: size.width/2, y: CGFloat(startingPoint+Int(size.height)))
        section.fillColor = .white
        section.strokeColor = .white
        
        
        
        
        blocks.append(section)
        addChild(blocks[currentBlock])
        
        var moveSpeedCheck:CGFloat
        
        if moveSpeed < 0.4 {
            moveSpeedCheck = 0.4
        } else {
            moveSpeedCheck = CGFloat(moveSpeed)
        }
        if first {
            moveTo = startingPoint
        } else {
            print("CURRENT: ", currentBlock)
            if currentBlock == 1 {
                moveTo = Int(blocks[lastBlock()].position.y + 600)
            } else {
                moveTo = Int(blocks[lastBlock()-1].position.y + 600)
            }
        }
        var moveDown = SKAction()
        var moveLeft = SKAction()
        var moveRight = SKAction()
        if first {
            print("STARTING: ", startingPoint)
            moveLeft = SKAction.move(to: CGPoint(x: size.width/2-400, y:  CGFloat(startingPoint)), duration: TimeInterval(moveSpeedCheck))
            moveRight = SKAction.move(to: CGPoint(x: size.width/2+400, y:  CGFloat(startingPoint)), duration: TimeInterval(moveSpeedCheck))
            moveDown = SKAction()
            
            print("first anim")
            moveDown = SKAction.move(to: CGPoint(x: size.width/2, y: CGFloat(startingPoint)), duration: 0.1)
            
            
            
            
        } else {
            print("STARTING: ", moveTo)
            moveLeft = SKAction.move(to: CGPoint(x: size.width/2-400, y:  CGFloat(moveTo)), duration: TimeInterval(moveSpeedCheck))
            moveRight = SKAction.move(to: CGPoint(x: size.width/2+400, y:  CGFloat(moveTo)), duration: TimeInterval(moveSpeedCheck))
            moveDown = SKAction()
            
            print("else anim")
            moveDown = SKAction.move(to: CGPoint(x: size.width/2, y: CGFloat(moveTo)), duration: 1)
        }
        moveDown.timingMode = .easeOut
        blocks[currentBlock].run(moveDown)
        
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
    
    
    
    func lostGame() {
        /*
         self.removeAllChildren()
         self.removeAllActions()
         self.removeFromParent()
         self.view?.presentScene(nil)
         */
        if lost && !lostOnce {
            //lost = true
            lostOnce = true
            failureRect.position.y = CGFloat(0)
            //blocks[currentBlock].removeFromParent()
            let blockBody = SKPhysicsBody(polygonFrom: blocks[currentBlock].path!)
            blockBody.mass = 500
            blockBody.friction = 500.0
            blockBody.contactTestBitMask = 0
            blockBody.categoryBitMask = 1
            blockBody.restitution = 0
            
            blocks[currentBlock].removeAllActions()
            blocks[currentBlock].physicsBody = blockBody
            blocks[currentBlock].physicsBody?.isDynamic = true
            
            
            let cameraMoveEnd = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2), duration: 2)
            cameraMoveEnd.timingMode = .easeOut
            cameraNode.run(cameraMoveEnd)
            
            
            
            let loser2 = SKLabelNode()
            let loserMove = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/2+200), duration: 0.5)
            loserMove.timingMode = .easeOut
            loser.text = "X"
            loser2.text = "O"
            loser.fontSize = 500
            loser2.fontSize = 500
            loser.fontColor = SKColor.red
            loser2.fontColor = SKColor.red
            loser.position = CGPoint(x: size.width/2, y: cameraNode.position.y+size.height)
            loser2.position = CGPoint(x: size.width/2, y: cameraNode.position.y+size.height)
            addChild(loser)
            //
            //
            //
            //addChild(loser2)
            
            
            
            let hsMove = SKAction.move(to: CGPoint(x: size.width/2+400, y: size.height/2+200), duration: 0.5)
            hsMove.timingMode = .easeOut
            highScoreText.position = CGPoint(x: size.width*2, y: cameraNode.position.y-200)
            highScoreText.fontSize = 200
            
            if let scoreSaved:Int = UserDefaults.standard.integer(forKey: "highScore") {
                if scoreSaved < score {
                    highScoreText.text = String(score)
                    print("High score higher" , score , ", " , scoreSaved)
                    highScore = score
                    UserDefaults.standard.set(score, forKey: "highScore")
                    UserDefaults.standard.synchronize()
                } else {
                    highScoreText.text = String(scoreSaved)
                }
            }
            addChild(highScoreText)
            highScoreText.run(hsMove)
            loser.run(loserMove)
            
            let animScoreEnd = SKAction.move(to: CGPoint(x: size.width/2-400, y: size.height/2+200), duration: 0.5)
            animScoreEnd.timingMode = .easeOut
            scoreText.run(animScoreEnd)
            
            //loser2.run(loserMove)
            //lost = true
            
            
            /*
             buttonLose = SKShapeNode(rectOf: CGSize(width: 200, height: 200))
             buttonLose.fillColor = .red
             buttonLose.position = CGPoint(x: size.width/2, y: size.height/2)
             buttonLose.name = "LoseButton"
             lost = true
             addChild(buttonLose)*/
            
            
            
            
            //restart()
            
        }
    }
    
    func moveScreen() {
        var moveInt:CGFloat
        
        moveInt = blocks[lastBlock()-1].position.y + 800
        
        let moveFail = (blocks[lastBlock()-1].position.y + 800) - (size.height-750)
        let moveFail2 = (blocks[lastBlock()-1].position.y + 800) - (size.height-450)
        let moveFail3 = (blocks[lastBlock()-1].position.y + 800) - (size.height-150)
        failureRect.position.y = moveFail
        failureRect2.position.y = moveFail2
        failureRect3.position.y = moveFail3
        
        let moveIntScore = blocks[lastBlock()-1].position.y + 1100
        let camMove = SKAction.move(to: CGPoint(x: cameraNode.position.x, y: moveInt), duration: 0.5)
        let scoreMove = SKAction.move(to: CGPoint(x: scoreText.position.x, y: moveIntScore), duration: 0.5)
        camMove.timingMode = .easeOut
        scoreMove.timingMode = .easeOut
        cameraNode.run(camMove)
        scoreText.run(scoreMove)
    }
    
    func moveLostElements() {
        print("MOVE ELEMENTS: ", lost)
        if lost {
            let hsMove = SKAction.move(to: CGPoint(x: size.width*2, y: cameraNode.position.y-200), duration: 1)
            hsMove.timingMode = .easeOut
            
            let loseMove = SKAction.move(to: CGPoint(x: size.width*2, y: cameraNode.position.y), duration: 1)
            loseMove.timingMode = .easeOut
            
            highScoreText.run(hsMove)
            loser.run(loseMove, completion: {
                self.restart()
            })
        }
    }
    
    func setupLedges() {
        scoreText.text = String(score)
        scoreText.fontColor = .white
        scoreText.fontSize = 200
        scoreText.position = CGPoint(x: size.width/4, y: size.height*2+100)
        addChild(scoreText)
        let scoreAnim = SKAction.move(to: CGPoint(x: size.width/4, y: size.height/2+300), duration: 1)
        scoreAnim.timingMode = .easeOut
        scoreText.run(scoreAnim)
        
        failureRect = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height/3))
        failureRect2 = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height/3))
        failureRect3 = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height/3))
        
        failureRect.position = CGPoint(x: size.width/2, y: CGFloat(-300))
        
        failureRect.strokeColor = .clear
        
        failureRect2.position = CGPoint(x: size.width/2, y: CGFloat(-600))
        
        failureRect2.strokeColor = .clear
        
        failureRect3.position = CGPoint(x: size.width/2, y: CGFloat(-900))
        
        failureRect3.strokeColor = .clear
        let failureBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width*4, height: size.height/3))
        failureBody.categoryBitMask = 0
        failureBody.collisionBitMask = 0
        failureBody.contactTestBitMask = 1
        failureBody.isDynamic = false
        
        let failureBody2 = SKPhysicsBody(rectangleOf: CGSize(width: size.width*4, height: size.height/3))
        failureBody2.categoryBitMask = 0
        failureBody2.collisionBitMask = 0
        failureBody2.contactTestBitMask = 1
        failureBody2.isDynamic = false
        
        let failureBody3 = SKPhysicsBody(rectangleOf: CGSize(width: size.width*4, height: size.height/3))
        failureBody3.categoryBitMask = 0
        failureBody3.collisionBitMask = 0
        failureBody3.contactTestBitMask = 1
        failureBody3.isDynamic = false
        failureRect.physicsBody = failureBody
        failureRect2.physicsBody = failureBody2
        failureRect3.physicsBody = failureBody3
        
        
        
        addChild(failureRect)
        addChild(failureRect2)
        addChild(failureRect3)
        addChild(cameraNode)
        
        camera = cameraNode
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
    }
    
    func winner() { //You won
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
    
    func restart() { //Restart the game by clearing and reseting variables
        currentBlock = 0
        moveSpeed = 1.0
        startingPoint = 100
        first = true
        score = 0
        cameraNode.removeAllActions()
        cameraNode.position.y = size.height/2
        won = false
        lost = false
        left = false
        lostOnce = false
        
        
        blocks.removeAll()
        self.removeAllChildren()
        self.removeAllActions()
        setupLedges()
        addBlock()
    }
    
    func cleanBlocks() {
        let blockBody = SKPhysicsBody(polygonFrom: blocks[currentBlock].path!)
        
        blockBody.mass = 500
        blockBody.friction = 500.0
        blockBody.contactTestBitMask = 0
        blockBody.categoryBitMask = 1
        blocks[currentBlock].removeAllActions()
        blocks[currentBlock].physicsBody = blockBody
        blocks[0].physicsBody?.isDynamic = true
        isFalling = true
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode {
            print("CONTACT")
            print("NODE B Y: " , nodeB.physicsBody?.velocity.dy)
            print("NODE A Y: " , nodeA.physicsBody?.velocity.dy)
            print("NODE B X: " , nodeB.physicsBody?.velocity.dx)
            print("NODE A X: " , nodeA.physicsBody?.velocity.dx)
            if (nodeB.physicsBody?.velocity.dy)! < CGFloat(-400.0) || (nodeA.physicsBody?.velocity.dy)! < CGFloat(-400.0) /*&& (nodeB.physicsBody?.velocity.dx)! > CGFloat(0) || (nodeA.physicsBody?.velocity.dx)! > CGFloat(0) */&& !lost{
                print("FAST")
                lost = true
                /*if (nodeB.physicsBody?.velocity.dy)! < CGFloat(-200.0) && !lost{
                 
                 
                 // Honestly idk how this part even works
                 // its so bad, but at least it works
                 
                 
                 nodeB.fillColor = .red
                 nodeB.strokeColor = .red
                 } else if !lost {
                 nodeA.fillColor = .red
                 nodeA.strokeColor = .red
                 }*/
                lostGame()
                
            }
            
        }
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
