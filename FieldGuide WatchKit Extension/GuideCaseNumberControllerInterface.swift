//
//  GuideCaseNumberControllerInterface.swift
//  FieldGuide
//
//  Created by SESP Walkup on 3/5/17.
//  Copyright © 2017 SESP Walkup. All rights reserved.
//

import WatchKit
import WatchConnectivity

class GuideCaseNumberControllerInterface: WKInterfaceController, WCSessionDelegate {
    
    var prompt: Prompt? {
        didSet {
            if prompt != nil {
                
            }
        }
    }
    
    override func awake (withContext: Any?) {
        super.awake(withContext: withContext)
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            //session.activate()
        }
        if let prompt = withContext as? Prompt { self.prompt = prompt }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            //session.activate()
        }
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, Any>()
        
        switch message["command"] as! String {
        case "Rail" :
            replyValues["status"] = "Done"
            // reload base controller
            self.presentController(withName: "atRail", context: self.prompt)
            WKInterfaceDevice.current().play(.notification)
        default:
            break
        }
        replyHandler(replyValues)
    }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
