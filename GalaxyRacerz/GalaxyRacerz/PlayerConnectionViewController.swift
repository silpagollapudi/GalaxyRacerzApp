//
//  ViewController.swift
//  Project25
//
//  Created by TwoStraws on 19/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import MultipeerConnectivity
import UIKit
import SceneKit

//var mpc = MultiplayerConnection()

//var peerID: MCPeerID!
//var mcSession: MCSession!
//var mcAdvertiserAssistant: MCAdvertiserAssistant!

class PlayerConnectionViewController: UIViewController, UINavigationControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //var mpc = MultiplayerConnection()

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    }
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer:  peerID, securityIdentity: nil, encryptionPreference: .optional)
        mcSession.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func connect(_ sender: Any) {
        showConnectionPrompt()
    }
    
    func startHosting(action: UIAlertAction) {
        print("session started by " + UIDevice.current.name)
         mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session:  mcSession)
         mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction) {
        print("session joined by " + UIDevice.current.name)
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session:  mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "mpGame") as! MultiplayerGameViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
        print("transition start")
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    //var g = "hello"
    
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        print("data received")
//        //if let image = UIImage(data: data) {
//            DispatchQueue.main.async { [unowned self] in
//                var backToString = String(data: data, encoding: String.Encoding.utf8) as String?
//                let x = backToString
//            }
//    }
//
//    func sendImage() -> Data {
//        print("data sent")
//        let vc = GameViewController()
//        let x = NSKeyedArchiver.archivedData(withRootObject: vc)
//        if mpc.mcSession.connectedPeers.count > 0 {
//            do {
//                try mpc.mcSession.send(x, toPeers: mpc.mcSession.connectedPeers, with: .reliable)
//            } catch let error as NSError {
//                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default))
//                present(ac, animated: true)
//            }
//        }
//        return x
//    }
    
}

