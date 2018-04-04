//
//  GameViewController.swift
//  GalaxyRacerz
//
//  Created by Shailen Patel on 3/19/18.
//  Copyright © 2018 patel. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate {
    
    var ship = SCNNode()
    var scene = SCNScene()
    var scnView = SCNView()
    var gameOver = false
    let queue = DispatchQueue.global()
    let queue2 = DispatchQueue(label: "scoreQueue", qos: .userInitiated)
    var date = Date()
    var time = TimeInterval()
    var asteroidSpawnTime: TimeInterval = 0
    var earthSpawnTime: TimeInterval = 0
    var jupiterSpawnTime: TimeInterval = 0
    var uranusSpawnTime: TimeInterval = 0
    var leftOrRight = false
    var asteroidID = 2
    var earthID = 3
    var planetID = 4
    var asteroid = SCNNode()
    var asteroidScene = SCNScene()
    var scoreUI = SCNText(string: "0", extrusionDepth: 0.0)
    var scoreNode = SCNNode()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // create a new scene
        scene = SCNScene(named: "art.scnassets/ship.scn")!
        scene.physicsWorld.contactDelegate = self
        
        asteroidScene = SCNScene(named: "art.scnassets/asteroid.scn")!
        asteroidScene.physicsWorld.contactDelegate = self
        asteroid = asteroidScene.rootNode.childNode(withName: "asteroid", recursively: true)!
        
        //creates and adds camera node to scene
        createCameraAndLight()
        
        //set background of scene
        scene.background.contents = UIImage(named: "space")
        
        // retrieve the ship node
        ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        ship.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        
        // change ship color
        let image = UIImage(named: "textureYellow")
        let shipColor = scene.rootNode.childNode(withName: "shipMesh", recursively: true)!
        let material = shipColor.geometry?.firstMaterial!
        material?.diffuse.contents = image
        
        // detects interaction between asteroids and ship
        ship.physicsBody!.categoryBitMask = 1
        
        scoreUI.font = UIFont(name: "MandroidBB", size: 20)
        scoreUI.firstMaterial?.diffuse.contents = UIColor.red
        scoreNode = SCNNode(geometry: scoreUI)
        scoreNode.position = SCNVector3(x: -6, y: 25, z: -60)
        scene.rootNode.addChildNode(scoreNode)
        
        // retrieve the SCNView
        scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        //eplosion
        scnView.scene?.physicsWorld.contactDelegate = self
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = false
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.isUserInteractionEnabled = true
        scnView.addGestureRecognizer(tapGesture)
        
    }
    
    var done = false
    var contact = SCNPhysicsContact()
    var score = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(!gameOver) {
            queue.async {
                while(!self.gameOver) {
                    self.time = -self.date.timeIntervalSinceNow
                    self.updateScore(increment: 2)
                    self.scoreUI.string = NSString(format:"%d", self.score) as String
                    if(self.time > self.asteroidSpawnTime) {
                        DispatchQueue.main.async {
                            self.createAsteroid()
                        }
                        self.asteroidSpawnTime = self.time + TimeInterval(arc4random_uniform(8) + 1);
                    }
                    else if(self.time > self.earthSpawnTime) {
                        DispatchQueue.main.async {
                            self.createEarth(scene: self.scene)
                        }
                        self.earthSpawnTime = self.time + TimeInterval(arc4random_uniform(20) + 1);
                    }
                    else if(self.time > self.uranusSpawnTime) {
                        DispatchQueue.main.async {
                            self.createUranus(scene: self.scene)
                        }
                        self.uranusSpawnTime = self.time + TimeInterval(arc4random_uniform(15) + 1);
                    }
                    else if(self.time > self.jupiterSpawnTime) {
                        DispatchQueue.main.async {
                            self.createJupiter(scene: self.scene)
                        }
                        self.jupiterSpawnTime = self.time + TimeInterval(arc4random_uniform(10) + 1);
                    }
                }
            }
        }
    }
    
    func updateScore(increment: Int) {
        queue2.async {
            sleep(2)
            self.score += increment
        }
    }
    
    func createCameraAndLight() {
        //let cameraNode = SCNNode()
        let cameraNode = SCNNode()
        
        // create and add a camera to the scene
        //let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        // place the camera
        
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 31)
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    func lock(obj: AnyObject, blk:() -> ()) {
        objc_sync_enter(obj)
        blk()
        objc_sync_exit(obj)
    }
    
    //var mutex = 1
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA == ship || contact.nodeA.physicsBody?.categoryBitMask == asteroidID) && (contact.nodeB == ship || contact.nodeB.physicsBody?.categoryBitMask == asteroidID) {
            //lock(obj: mutex as AnyObject) {
                let particleSystem = SCNParticleSystem(named: "Explosion.scnp", inDirectory: nil)
                let systemNode = SCNNode()
                systemNode.addParticleSystem(particleSystem!)
                systemNode.position = contact.nodeA.position
                scnView.scene?.rootNode.addChildNode(systemNode)
                gameOver = true
                ship.removeFromParentNode()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.75, execute: {
                    self.ship.removeFromParentNode()
                    self.performSegue(withIdentifier: "GameOverSegue", sender:AnyClass.self)
                })
            //}
        }
        
        else if (contact.nodeA == ship || contact.nodeA.physicsBody?.categoryBitMask == earthID) && (contact.nodeB == ship || contact.nodeB.physicsBody?.categoryBitMask == earthID) {
            if (contact.nodeA.physicsBody?.categoryBitMask == earthID) {
                contact.nodeA.removeFromParentNode()
            } else {
                contact.nodeB.removeFromParentNode()
            }
            score = score + 10
            
        } else if (contact.nodeA == ship || contact.nodeA.physicsBody?.categoryBitMask == planetID) && (contact.nodeB == ship || contact.nodeB.physicsBody?.categoryBitMask == planetID) {
            if (contact.nodeA.physicsBody?.categoryBitMask == planetID) {
                contact.nodeA.removeFromParentNode()
            } else {
                contact.nodeB.removeFromParentNode()
            }
            score = score - 5
        }
    }
    
    func createAsteroid() {
        let newAsteroid = asteroid.clone()
        var xCoord = 0
        if(leftOrRight) {
            xCoord = Int(arc4random_uniform(8) + 1)
        }
        else {
            xCoord = -1 * Int(arc4random_uniform(8))
        }
        leftOrRight = !leftOrRight
        newAsteroid.position = SCNVector3(Double(xCoord), 5.0, -92.0)
        let body = SCNPhysicsBody(type: .dynamic, shape: nil)
        newAsteroid.physicsBody = body
        newAsteroid.physicsBody?.velocity = SCNVector3(0, 0, 70)
        scene.rootNode.addChildNode(newAsteroid)
        
        newAsteroid.physicsBody!.categoryBitMask = asteroidID
        newAsteroid.physicsBody!.contactTestBitMask = 1
        
    }
    
    func createEarth(scene: SCNScene) {
        let sphere = SCNSphere(radius: 2)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named:"earth.png")
        var xCoord = 0
        if(leftOrRight) {
            xCoord = Int(arc4random_uniform(8) + 1)
        }
        else {
            xCoord = -1 * Int(arc4random_uniform(8))
        }
        leftOrRight = !leftOrRight
        sphereNode.position = SCNVector3(Double(xCoord), 5.0, -60.0)
        let body = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereNode.physicsBody = body
        sphereNode.physicsBody?.velocity = SCNVector3(0, 0, 58)
        scene.rootNode.addChildNode(sphereNode)
        
        sphereNode.physicsBody!.categoryBitMask = earthID
        sphereNode.physicsBody!.contactTestBitMask = 1
    }
    
    func createUranus(scene: SCNScene) {
        let sphere = SCNSphere(radius: 1.5)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named:"Uranus.png")
        var xCoord = 0
        if(leftOrRight) {
            xCoord = Int(arc4random_uniform(8) + 1)
        }
        else {
            xCoord = -1 * Int(arc4random_uniform(8))
        }
        leftOrRight = !leftOrRight
        sphereNode.position = SCNVector3(Double(xCoord), 5.0, -60.0)
        let body = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereNode.physicsBody = body
        sphereNode.physicsBody?.velocity = SCNVector3(0, 0, 58)
        scene.rootNode.addChildNode(sphereNode)
        
        sphereNode.physicsBody!.categoryBitMask = planetID
        sphereNode.physicsBody!.contactTestBitMask = 1
    }
    
    func createJupiter(scene: SCNScene) {
        let sphere = SCNSphere(radius: 3)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named:"Jupiter.png")
        var xCoord = 0
        if(leftOrRight) {
            xCoord = Int(arc4random_uniform(8) + 1)
        }
        else {
            xCoord = -1 * Int(arc4random_uniform(8))
        }
        leftOrRight = !leftOrRight
        sphereNode.position = SCNVector3(Double(xCoord), 5.0, -60.0)
        let body = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereNode.physicsBody = body
        sphereNode.physicsBody?.velocity = SCNVector3(0, 0, 58)
        scene.rootNode.addChildNode(sphereNode)
        
        sphereNode.physicsBody!.categoryBitMask = planetID
        sphereNode.physicsBody!.contactTestBitMask = 1
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIPanGestureRecognizer) {
        if(!gameOver) {
            // retrieve the SCNView
            let scnView = self.view as! SCNView
        
            // check what nodes are tapped
            let p = gestureRecognize.location(in: scnView)
            let hitResults = scnView.hitTest(p, options: [:])
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result = hitResults[0]
                //let node = result.node
                
                let projectedOrigin = scnView.projectPoint((ship.position))
                
                //Location of the finger in the view on a 2D plane
                let location2D = gestureRecognize.location(in: scnView)
                
                //Location of the finger in a 3D vector
                let location3D = SCNVector3(Float(location2D.x), Float(location2D.y), projectedOrigin.z)
                
                //Unprojects a point from the 2D pixel coordinate system of the renderer to the 3D world coordinate system of the scene
                let realLocation3D = scnView.unprojectPoint(location3D)
                
                //Only updating X axis position
                ship.position = SCNVector3(realLocation3D.x, (ship.position.y), (ship.position.z))
                
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "GameOverSegue",
            let destination = segue.destination as? GameOverViewController {
            
            destination.tempScoreLabel = String(score)
            
        }
        
     }
     


}
