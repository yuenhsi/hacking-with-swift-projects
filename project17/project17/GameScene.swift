//
//  GameScene.swift
//  project17
//
//  Created by Yuen Hsi Chang on 12/28/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//

import SpriteKit

enum ForceBomb {
    case never, always, random
}

enum SequenceType: Int {
    case oneNoBomb, one, twoOneBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var lives = 3
    var livesImage = [SKSpriteNode]()
    var activeSliceYellow: SKShapeNode!
    var activeSliceWhite: SKShapeNode!
    var activeSlicePoints = [CGPoint]()
    var activeEnemies = [SKSpriteNode]()
    var isSwooshSoundActive = false
    var popupTime = 0.9
    var sequence: [SequenceType]!
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true
    var gameEnded = false
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()

        sequence = [.oneNoBomb, .oneNoBomb, .twoOneBomb, .twoOneBomb, .three, .one, .chain]
        
        for _ in 0 ... 1000 {
            let nextSequence = SequenceType(rawValue: RandomInt(min: 2, max: 7))!
            sequence.append(nextSequence)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.tossEnemies()
        }
    }
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "ChalkDuster")
        gameScore.text = "Score: \(score)"
        gameScore.fontSize = 48
        gameScore.horizontalAlignmentMode = .left
        gameScore.position = CGPoint(x: 8, y: 8)
        addChild(gameScore)
    }
    
    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImage.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceYellow = SKShapeNode()
        activeSliceYellow.zPosition = 2
        activeSliceYellow.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceYellow.lineWidth = 9
        
        activeSliceWhite = SKShapeNode()
        activeSliceWhite.zPosition = 2
        activeSliceWhite.strokeColor = UIColor.white
        activeSliceWhite.lineWidth = 5
        
        addChild(activeSliceYellow)
        addChild(activeSliceWhite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSlicePoints.removeAll(keepingCapacity: true)
        if let touch = touches.first {
            let location = touch.location(in: self)
            activeSlicePoints.append(location)
            redrawActiveSlice()
            activeSliceWhite.removeAllActions()
            activeSliceYellow.removeAllActions()
            activeSliceWhite.alpha = 1
            activeSliceYellow.alpha = 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded {
            return
        }
        guard let touch = touches.first else {  return  }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if (!isSwooshSoundActive) {
            playSwooshSound()
        }
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "enemy" {
                let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy")!
                emitter.position = node.position
                addChild(emitter)
                node.name = ""
                node.physicsBody!.isDynamic = false
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                let seq = SKAction.sequence([group, SKAction.removeFromParent()])
                node.run(seq)
                score += 1
                let index = activeEnemies.index(of: node as! SKSpriteNode)!
                activeEnemies.remove(at: index)
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "bomb" {
                let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy")!
                emitter.position = node.position
                addChild(emitter)
                node.name = ""
                node.physicsBody!.isDynamic = false
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])
                let seq = SKAction.sequence([group, SKAction.removeFromParent()])
                node.parent!.run(seq)
                let index = activeEnemies.index(of: node.parent as! SKSpriteNode)!
                activeEnemies.remove(at: index)
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceYellow.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceWhite.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touches.isEmpty {
            touchesEnded(touches, with: event)
        }
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceWhite.path = nil
            activeSliceYellow.path = nil
            return
        }
        while activeSlicePoints.count > 12 {
            activeSlicePoints.remove(at: 0)
        }
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        activeSliceYellow.path = path.cgPath
        activeSliceWhite.path = path.cgPath
    }
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        var enemy: SKSpriteNode
        var enemyType = RandomInt(min: 0, max: 6)
        
        if forceBomb == .never {
            enemyType = 1
        }
        if forceBomb == .always {
            enemyType = 0
        }
        if enemyType == 0 {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            let emitter = SKEmitterNode(fileNamed: "sliceFuse")!
            emitter.position = CGPoint(x: 76, y: 64)
            enemy.addChild(emitter)
            
            run(SKAction.playSoundFileNamed("sliceBombFuse.caf", waitForCompletion: false))
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }
        let randomPosition = CGPoint(x: RandomInt(min: 64, max: 960), y: -128)
        let randomAngularVelocity = CGFloat(RandomInt(min: -6, max: 6))
        var randomXVelocity = 0
        if randomPosition.x < 256 {
            randomXVelocity = RandomInt(min: 8, max: 15)
        } else if randomPosition.x < 512 {
            randomXVelocity = RandomInt(min: 3, max: 5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -RandomInt(min: 3, max: 5)
        } else {
            randomXVelocity = -RandomInt(min: 8, max: 15)
        }
        let randomYVelocity = RandomInt(min: 24, max: 32)
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody!.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody!.angularVelocity = randomAngularVelocity
        enemy.physicsBody!.collisionBitMask = 0
        enemy.position = randomPosition
        addChild(enemy)

        activeEnemies.append(enemy)
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        let randomNumber = RandomInt(min: 1, max: 3)
        let soundName = "swoosh\(randomNumber).caf"
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        run(swooshSound) { [unowned self] in
            self.isSwooshSoundActive = false
        }
    }
    
    func tossEnemies() {
        if gameEnded {
            return
        }
        popupTime *= 0.991
        chainDelay *= 0.991
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        case .one:
            createEnemy()
        case .twoOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
        case .two:
            createEnemy()
            createEnemy()
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
        case .chain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [unowned self] in
                self.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0) * 2) { [unowned self] in
                self.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0) * 3) { [unowned self] in
                self.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0) * 4) { [unowned self] in
                self.createEnemy()
            }
        case .fastChain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [unowned self] in
                self.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0) * 2) { [unowned self] in
                self.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0) * 3) { [unowned self] in
                self.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0) * 4) { [unowned self] in
                self.createEnemy()
            }
        }
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for node in activeEnemies {
                if node.position.y < -140 {
                    node.removeAllActions()
                    if node.name == "enemy" {
                        node.name = ""
                        subtractLife()
                        node.removeFromParent()
                        if let index = activeEnemies.index(of: node) {
                            activeEnemies.remove(at: index)
                        
                        }
                    }
                    else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        if let index = activeEnemies.index(of: node) {
                            activeEnemies.remove(at: index)
                        }
                    }
                }
            }
        }
        else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [unowned self] in
                    self.tossEnemies()
                }
                nextSequenceQueued = true
            }
        }
    }
    
    func subtractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caff", waitForCompletion: false))
        var life: SKSpriteNode
        if lives == 2 {
            life = livesImage[0]
        } else if lives == 1 {
            life = livesImage[1]
        } else {
            life = livesImage[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    func endGame(triggeredByBomb: Bool) {
        if gameEnded {
            return
        }
        gameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        if triggeredByBomb {
            livesImage[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImage[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImage[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
    }
}
