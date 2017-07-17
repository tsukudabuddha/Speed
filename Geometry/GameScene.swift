//
//  GameScene.swift
//  Geometry
//
//  Created by Andrew Tsukuda on 7/14/17.
//  Copyright © 2017 Andrew Tsukuda. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum GameState {
    case running, finished
}

class GameScene: SKScene {
    
    var motionManager: CMMotionManager!
    var ball: SKShapeNode!
    var speedLabel: SKLabelNode!
    var highSpeedLabel: SKLabelNode!
    var beginLabel: SKLabelNode!
    var gameState: GameState = .finished
    
    
    var currentHighSpeed: Double = 0
    
    let accelerometerSpeed: CGFloat = 2000
    
    var time: CFTimeInterval = 0.0
    let delta: CFTimeInterval = 1.0 / 60.0
    
    
    override func didMove(to view: SKView) {
        /* Runs on scene spawn */
        beginLabel = childNode(withName: "beginLabel") as! SKLabelNode
        /* Set up Motion Manager */
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if gameState != .running { return }
        
        if let data = motionManager.accelerometerData {
            ball.physicsBody?.applyForce(CGVector(dx: accelerometerSpeed * CGFloat(data.acceleration.x), dy: accelerometerSpeed * CGFloat(data.acceleration.y)))
        }
        
        /* Check currentSpeed and compare to highSpeed */
        let speed = ( (abs(Double((ball.physicsBody?.velocity.dx)!))) + (abs(Double((ball.physicsBody?.velocity.dy)!))) ) / 100
        
        if currentHighSpeed < speed {
            currentHighSpeed = speed
        }
        
        /* Print High Speed and Speed */
        
        highSpeedLabel.text = String(currentHighSpeed.rounded())
        speedLabel.text = String(Int(speed))
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Get first touch */
        let touch = touches.first!
        
        /* Get location of touch and see what it is touching */
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        /* Check if the touched node is the begin label */
        if touchedNode == beginLabel {
            setupScene()
            gameState = .running
            beginLabel.isHidden = true
        }
    }
    
    
    func setupScene() {
        
        let originPoint = CGPoint(x: 0, y: 0)
        // Create puck object and attach to scene
        ball = SKShapeNode(circleOfRadius: 15 ) // Size of Circle
        ball.position = originPoint  //Middle of Screen
        ball.strokeColor = UIColor.white
        ball.glowWidth = 1
        ball.fillColor = UIColor.cyan
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.pinned = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.mass = 0.001
        ball.physicsBody?.categoryBitMask = 2
        ball.physicsBody?.collisionBitMask = 1
        ball.physicsBody?.fieldBitMask = 0
        ball.physicsBody?.contactTestBitMask = 1
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 0.1
        ball.physicsBody?.mass = 0.5
        // this will allow the balls to rotate when bouncing off each other
        ball.physicsBody?.allowsRotation = true
        
        ball.zPosition = 1
        self.addChild(self.ball)
        
        // Draw Middle circle
        let middleCircle = SKShapeNode(circleOfRadius: 150) // Size of circle
        middleCircle.position = originPoint
        middleCircle.strokeColor = UIColor.white
        middleCircle.glowWidth = 1
        middleCircle.fillColor = self.backgroundColor
        middleCircle.physicsBody = SKPhysicsBody(edgeLoopFrom: middleCircle.path!)
        middleCircle.physicsBody?.affectedByGravity = false
        middleCircle.physicsBody?.isDynamic = false
        middleCircle.physicsBody?.pinned = true
        
        self.addChild(middleCircle)
        
        speedLabel = SKLabelNode()
        addChild(speedLabel)
        
        highSpeedLabel = SKLabelNode()
        highSpeedLabel.position.y += 40
        addChild(highSpeedLabel)

    }
}
