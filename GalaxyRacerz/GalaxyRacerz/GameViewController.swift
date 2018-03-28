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

class GameViewController: UIViewController {
    
    let cameraNode = SCNNode()
    var cameraCurrentZoomScale = 10.0
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var lastPositionX: Float = 0.0
    var lastPositionY: Float = 0.0
    var maxXPositionRight: Float = 4.0
    var maxXPositionLeft: Float = -4.0
    var maxYPositionUp: Float = 3.0
    var maxYPositionDown: Float = -3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //let cameraNode = SCNNode()

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
        //ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
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
        
        let trans2D:CGPoint = tapGesture.translation(in:self.view)
        let transPoint3D:SCNVector3 = SCNVector3Make(Float(trans2D.x), Float(trans2D.y), Float(0))
        
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
            
            let trans:SCNVector3 = scnView.unprojectPoint(SCNVector3Zero)
            let pos:SCNVector3 = node.presentation.position
            let newPos = 2 * ((trans.x) + (pos.x))
            node.position.x = newPos
            
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
