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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //let cameraNode = SCNNode()
        let cameraNode = SCNNode()

        // create and add a camera to the scene
        //let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        // place the camera
        
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 31)
        //cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        //set background of scene
        scene.background.contents = UIImage(named: "space")
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        // animate the 3d object
        
        //adds asteroid object
        let asteroid = createAsteroid(scene: scene)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView 
        
        // set the scene to the view
        scnView.scene = scene
        
        //gesture
        let moveBy = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
        ship.runAction(moveBy)
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        scnView.isUserInteractionEnabled = true
        scnView.addGestureRecognizer(tapGesture)
        
    }
    
    func createAsteroid(scene: SCNScene) -> SCNNode {
        let sphere = SCNSphere(radius: 3)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0.0, 10.0, -20.0)
        var body = SCNPhysicsBody(type: .dynamic, shape: nil)
        body = SCNPhysicsBody.dynamic()
        sphereNode.physicsBody = body
        sphereNode.physicsBody?.velocity = SCNVector3(0,0,18)
        scene.rootNode.addChildNode(sphereNode)
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
            let location3D = SCNVector3Make(Float(location2D.x), Float(location2D.y), projectedOrigin.z)
            
            //Unprojects a point from the 2D pixel coordinate system of the renderer to the 3D world coordinate system of the scene
            let realLocation3D = scnView.unprojectPoint(location3D)
            
            //Only updating Y axis position
            node.position = SCNVector3Make(realLocation3D.x, (node.position.y), (node.position.z))
            
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

}
