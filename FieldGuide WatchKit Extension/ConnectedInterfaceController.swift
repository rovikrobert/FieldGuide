//
//  ConnectedInterfaceController.swift
//  FieldGuide
//
//  Created by SESP Walkup on 3/6/17.
//  Copyright © 2017 SESP Walkup. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ConnectedInterfaceController: WKInterfaceController, WCSessionDelegate {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        // Configure interface objects here.
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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, Any>()
        
        switch message["command"] as! String {
        case "Rail" :
            replyValues["status"] = "Done"
            // reload base controller
            self.dismiss()
            WKInterfaceDevice.current().play(.notification)
        case "Collect" :
            replyValues["status"] = "Done"
            // reload base controller
            self.presentController(withName: "CollectedScreen", context: nil)
            WKInterfaceDevice.current().play(.notification)
        default:
            break
        }
        replyHandler(replyValues)
    }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
}