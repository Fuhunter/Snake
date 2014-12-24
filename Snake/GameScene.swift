//
//  GameScene.swift
//  Snake
//
//  Created by Niclas Günther on 20.12.14.
//  Copyright (c) 2014 Niclas Günther. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum newSnakeDirection {
        case Up, Down, Left, Right
    }
    
    var didSetup: Bool = false
    
    var snakeTail: [SKNode] = []
    
    let kSnakeHeadMask: UInt32 = 0x1 << 0
    let kScreenMask: UInt32 = 0x1 << 1
    let kSnakeTailMask: UInt32 = 0x1 << 2
    let kPointMask : UInt32 = 0x1 << 3
    
    var snakeDirection = newSnakeDirection.Right
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        if !self.didSetup {
            self.didSetup = true
            self.setupView()
            self.setupSnake()
            self.newPoint()
            self.moveSnake()
        }
    }
    
    // Initial Setup
    
    func setupView() {
        self.view?.backgroundColor = UIColor.blackColor()
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.view!.frame)
        self.physicsBody!.categoryBitMask = self.kScreenMask
        self.physicsBody!.dynamic = false
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipeUp:"))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        
        self.view?.addGestureRecognizer(swipeUp)
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipeDown:"))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view?.addGestureRecognizer(swipeDown)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Right
        
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Left
        
        self.view?.addGestureRecognizer(swipeLeft)
    }
    
    func setupSnake() {
        let head = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(10, 10))
        head.position = CGPoint(x: self.view!.frame.width / 2 + 11, y: self.view!.frame.height / 2)
        head.name = "Snake Head"
        head.physicsBody = SKPhysicsBody(rectangleOfSize: head.size)
        head.physicsBody!.categoryBitMask = self.kSnakeHeadMask
        head.physicsBody!.collisionBitMask = self.kSnakeTailMask | self.kScreenMask
        head.physicsBody!.contactTestBitMask = self.kPointMask
        head.physicsBody!.dynamic = false
        head.physicsBody!.usesPreciseCollisionDetection = true
        
        self.snakeTail.append(head)
        self.addChild(head)
        
        for var i = 0; i <= 5; i++ {
            let tail = SKSpriteNode(color: UIColor.lightGrayColor(), size: CGSizeMake(10, 10))
            tail.name = "Snake Tail"
            tail.physicsBody = SKPhysicsBody(rectangleOfSize: tail.size)
            tail.physicsBody!.categoryBitMask = self.kSnakeTailMask
            tail.physicsBody!.dynamic = false
            
            if self.snakeTail.count == 1 {
                tail.position = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height / 2)
                self.snakeTail.append(tail)
            } else {
                let lastTail = self.snakeTail.last
                tail.position = CGPoint(x: lastTail!.position.x - 11, y: lastTail!.position.y)
                self.snakeTail.append(tail)
            }
            
            self.addChild(tail)
        }
    }
    
    func newPoint() {
        let pointX: CGFloat = CGFloat(UInt32(arc4random_uniform(800)) % UInt32(self.view!.frame.width))
        let pointY: CGFloat = CGFloat(UInt32(arc4random_uniform(1000)) % UInt32(self.view!.frame.height))
        
        let point = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(10, 10))
        point.position = CGPoint(x: pointX, y: pointY)
        point.physicsBody = SKPhysicsBody(rectangleOfSize: point.size)
        point.physicsBody!.categoryBitMask = self.kPointMask
        point.physicsBody!.dynamic = false
        point.physicsBody!.usesPreciseCollisionDetection = true
        
        self.addChild(point)
    }
    
    func moveSnake() {
        for snakePart in self.snakeTail {
            snakePart.position = CGPoint(x: snakePart.position.x + 0.5, y: snakePart.position.y)
        }
    }
    
    // Adding new tail for each point
    
    func addTail() {
        let tail = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(10, 10))
        tail.physicsBody = SKPhysicsBody(rectangleOfSize: tail.size)
        tail.physicsBody!.categoryBitMask = self.kSnakeTailMask
        tail.physicsBody!.dynamic = false
        
        let lastTail = self.snakeTail.last
        
        tail.position = CGPoint(x: lastTail!.position.x - 11, y: lastTail!.position.y)
        
        self.snakeTail.append(tail)
        
        self.addChild(tail)
    }
    
    // Handle directions
    
    func swipeUp(sender: UISwipeGestureRecognizer) {
        println("Up")
        self.snakeDirection = newSnakeDirection.Up
    }
    
    func swipeDown(sender: UISwipeGestureRecognizer) {
        println("Down")
        self.snakeDirection = newSnakeDirection.Down
    }
    
    func swipeRight(sender: UISwipeGestureRecognizer) {
        println("Right")
        self.snakeDirection = newSnakeDirection.Right
    }
    
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        println("Left")
        self.snakeDirection = newSnakeDirection.Left
    }
    
    // Handle Contact
    
    func didBeginContact(contact: SKPhysicsContact) {
        println(contact.bodyA.node?.name)
    }
    
    // Handle touches
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
    
    // Update Screen
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        self.moveSnake()
    }
}