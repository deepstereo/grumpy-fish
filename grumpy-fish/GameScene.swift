//
//  GameScene.swift
//  grumpy-fish
//
//  Created by Sergey Kozak on 19/02/2018.
//  Copyright © 2018 Centennial. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // obstacle arrays
    var bottomTextures = ["rock1", "rock2", "rock3", "rock4", "rock5", "rock6", "rock7", "column1"]
    var topTextures = ["coral1", "coral2", "coral3", "coral4", "coral5", "coral6"]
    
    // game objects
    var oceanFloor: SKSpriteNode!
    var oceanFloor2: SKSpriteNode!
    var fish: SKSpriteNode?
    var bottomObstacle: SKSpriteNode?
    var topObstacle: SKSpriteNode?
    
    // time intervals to randomize obstacles
    var bottomObstacleInterval: TimeInterval = 4
    var timeSinceBottomObstacleCreated: TimeInterval = 0
    var previousTime: TimeInterval = 0
    
    var topObstacleInterval: TimeInterval = 3.5
    var timeSinceTopObstacleCreated: TimeInterval = 0
    
    
    
    
    override func didMove(to view: SKView) {
        
        oceanFloor = (self.childNode(withName: "oceanFloor") as? SKSpriteNode)!
        oceanFloor2 = (self.childNode(withName: "oceanFloor2") as? SKSpriteNode)!
        
        fish = self.childNode(withName: "fish") as? SKSpriteNode
        
        // add cycled movement to ocean floor
        let oceanMovement = SKAction.move(by:  CGVector(dx: -oceanFloor.size.width, dy: 0), duration: 10)
        let oceanReset = SKAction.move(by: CGVector(dx: oceanFloor.size.width, dy: 0), duration: 0)
        let oceanSequence = SKAction.repeatForever(SKAction.sequence([oceanMovement, oceanReset]))
        oceanFloor.run(oceanSequence)
        oceanFloor2.run(oceanSequence)
 
    }
    
    // MARK: Create top and bottom obstacles randomly
    
    func addBottomObstacle(_ frameRate: TimeInterval) {
        
        timeSinceBottomObstacleCreated += frameRate
        if timeSinceBottomObstacleCreated < bottomObstacleInterval {
            return
        }
        
        // create node from one of the textures
        let randomTexture = Int(arc4random_uniform(UInt32(bottomTextures.count)))
        let bottomTexture = SKTexture(imageNamed: bottomTextures[randomTexture])
        bottomObstacle = SKSpriteNode(texture: bottomTexture, size: bottomTexture.size())
        bottomObstacle?.position = CGPoint(x: self.frame.width + (bottomObstacle?.size.width)!, y: bottomTexture.size().height / 2 - 10)
        bottomObstacle?.physicsBody = SKPhysicsBody(texture: bottomTexture, size: bottomTexture.size())
        bottomObstacle?.physicsBody?.isDynamic = false
        bottomObstacle?.physicsBody?.affectedByGravity = false
        bottomObstacle?.zPosition = 1
        let bottomObstacleMovement = SKAction.move(by: CGVector(dx: -self.frame.width * 2, dy: 0), duration: 12)
        bottomObstacle?.run(bottomObstacleMovement)
        self.addChild(bottomObstacle!)
        
        // remove node after time period for optimization
        let waitAction = SKAction.wait(forDuration: 13)
        let removeFromParent = SKAction.removeFromParent()
        bottomObstacle?.run(SKAction.sequence([waitAction, removeFromParent]))
        
        // update time since the last obstacle created
        timeSinceBottomObstacleCreated = drand48()
    }
    
    func addTopObstacle(_ frameRate: TimeInterval) {
        
        timeSinceTopObstacleCreated += frameRate
        if timeSinceTopObstacleCreated < topObstacleInterval {
            return
        }
        
        // create node from one of the textures
        let randomTexture = Int(arc4random_uniform(UInt32(topTextures.count)))
        let topTexture = SKTexture(imageNamed: topTextures[randomTexture])
        topObstacle = SKSpriteNode(texture: topTexture, size: topTexture.size())
        topObstacle?.position = CGPoint(x: self.frame.width + (topObstacle?.size.width)!, y: self.frame.height - (topObstacle?.size.height)! / 2) // check this
        topObstacle?.physicsBody = SKPhysicsBody(texture: topTexture, size: topTexture.size())
        topObstacle?.physicsBody?.isDynamic = false
        topObstacle?.physicsBody?.affectedByGravity = false
        topObstacle?.zPosition = 2
        
        // move obstacle and remove node after time period for optimization
        let topObstacleMovement = SKAction.move(by: CGVector(dx: -self.frame.width * 2, dy: 0), duration: 12.5)
        let waitAction = SKAction.wait(forDuration: 13)
        let removeFromParent = SKAction.removeFromParent()
        self.addChild(topObstacle!)
        topObstacle?.run(SKAction.sequence([topObstacleMovement, waitAction, removeFromParent]))
        
        
        // update time since the last obstacle created
        timeSinceTopObstacleCreated = drand48()

    }
    
    // MARK: Touches began
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        fish?.physicsBody?.isDynamic = true
        fish?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))

    }
    
    
    // MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        addBottomObstacle(currentTime - previousTime)
        addTopObstacle(currentTime - previousTime)
        previousTime = currentTime
    }
}
