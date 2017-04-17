//
//  InterfaceController.swift
//  FieldGuide WatchKit Extension
//
//  Created by SESP Walkup on 2/23/17.
//  Copyright © 2017 SESP Walkup. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    var prompts = Prompt.allPrompts()
    
    @IBOutlet var HomeTitleLabel: WKInterfaceLabel!
    
    @IBOutlet var HomeWelcomeText: WKInterfaceLabel!
    @IBOutlet var HomeTitleLogo: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, Any>()
        
        
        switch message["command"] as! String {
        case "Exhibit" :
            replyValues["status"] = "Done"
            let promptcount = prompts.count
            
            var controllersNames = [String?](repeating: nil, count:promptcount)
            var controllersContexts: [Prompt?] = [Prompt?](repeating: nil, count:promptcount)
            
            if (promptcount>0) {
                for i in 0...promptcount-1 {
                    controllersNames[i] = "ExhibitPrompts"
                    controllersContexts[i] = prompts[i]
                }
            }
            
            // reload base controller
            self.presentController(withNames: controllersNames as! [String], contexts: controllersContexts)
            WKInterfaceDevice.current().play(.notification)
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

