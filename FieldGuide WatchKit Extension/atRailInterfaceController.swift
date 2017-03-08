//
//  atRailInterfaceController.swift
//  FieldGuide
//
//  Created by SESP Walkup on 2/26/17.
//  Copyright © 2017 SESP Walkup. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class atRailInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var itemImg: WKInterfaceImage!
    @IBOutlet var hallName: WKInterfaceLabel!
    @IBOutlet var promptText: WKInterfaceLabel!
    @IBOutlet var railImg: WKInterfaceImage!
    
    var prompt: Prompt? {
        didSet {
            if let prompt = prompt {
                hallName.setText(prompt.area)
                promptText.setText(prompt.promptText)
                itemImg.setImageNamed("Artifact")
            }
        }
    }

    
    
    override func awake (withContext: Any?) {
        super.awake(withContext: withContext)
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        if let prompt = withContext as? Prompt { self.prompt = prompt }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, Any>()
        
        
        switch message["command"] as! String {
        case "Connect" :
            replyValues["status"] = "Done"
        
            self.presentController(withNames: ["ConnectedScreen"], contexts: nil)
            WKInterfaceDevice.current().play(.notification)
            WKInterfaceDevice.current().play(.notification)
        case "Exhibit" :
            replyValues["status"] = "Done"
            
            self.dismiss()
            WKInterfaceDevice.current().play(.notification)
        default:
            break
        }
        replyHandler(replyValues)
    }

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
    }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
