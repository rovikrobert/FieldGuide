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
