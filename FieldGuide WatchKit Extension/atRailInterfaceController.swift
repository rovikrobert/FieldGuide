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
                itemImg.setImageNamed("Logo")
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

    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
