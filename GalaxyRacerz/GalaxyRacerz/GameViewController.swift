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
    var gameOver = false
    let queue = DispatchQueue.global()
    var date = Date()
    var time = TimeInterval()
    var spawnTime: TimeInterval = 0
    var leftOrRight = false
    var asteroidID = 2
    var asteroid = SCNNode()
    var asteroidScene = SCNScene()
    
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
        
        // detects interaction between asteroids and ship
        ship.physicsBody!.categoryBitMask = 1
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView 
        
        // set the scene to the view
        scnView.scene = scene
        
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(!gameOver) {
            queue.async {
                while(!self.gameOver) {
                    self.time = -self.date.timeIntervalSinceNow
                    if(self.time > self.spawnTime) {
                        DispatchQueue.main.async {
                            self.createAsteroid()
                            self.createPlanet(scene: self.scene)
                        }
                        self.spawnTime = self.time + TimeInterval(arc4random_uniform(6) + 1);
                    }
                }
            }
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
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA == ship || contact.nodeA.physicsBody?.categoryBitMask == asteroidID) && (contact.nodeB == ship || contact.nodeB.physicsBody?.categoryBitMask == asteroidID) {
            ship.removeFromParentNode()
            gameOver = true
            DispatchQueue.main.sync {
                performSegue(withIdentifier: "GameOverSegue", sender: AnyClass.self)
            }
        }
    }
    
    func createAsteroid() {
        //let sphere = SCNSphere(radius: 2)
        //let sphereNode = SCNNode(geometry: sphere)
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
    
    func createPlanet(scene: SCNScene) -> SCNNode {
        let sphere = SCNSphere(radius: 1.5)
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
        
        sphereNode.physicsBody!.categoryBitMask = asteroidID
        sphereNode.physicsBody!.contactTestBitMask = 1
        
        return sphereNode
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIPanGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            let node = result.node
            
            let projectedOrigin = scnView.projectPoint((node.position))
            
            //Location of the finger in the view on a 2D plane
            let location2D = gestureRecognize.location(in: scnView)
            
            //Location of the finger in a 3D vector
            let location3D = SCNVector3(Float(location2D.x), Float(location2D.y), projectedOrigin.z)
            
            //Unprojects a point from the 2D pixel coordinate system of the renderer to the 3D world coordinate system of the scene
            let realLocation3D = scnView.unprojectPoint(location3D)
            
            //Only updating X axis position
            ship.position = SCNVector3(realLocation3D.x, (node.position.y), (node.position.z))
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
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
            
            // destination.scoreLabel.text = score
            
        }
        
     }
     


}
