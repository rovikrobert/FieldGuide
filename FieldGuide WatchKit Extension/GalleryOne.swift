//
//  GalleryOne.swift
//  FieldGuide
//
//  Created by SESP Walkup on 4/19/17.
//  Copyright © 2017 SESP Walkup. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class GalleryOne: WKInterfaceController,WCSessionDelegate {

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
        case "GalleryTwo" :
            replyValues["status"] = "Done"
            self.pushController(withName: "GalleryTwo", context: nil)
            self.buzz()
        default:
            break
        }
        replyHandler(replyValues)
    }
    
    func buzz(){
        WKInterfaceDevice.current().play(.notification)
        WKInterfaceDevice.current().play(.notification)
        WKInterfaceDevice.current().play(.notification)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
        HomeTitleLogo.setImageNamed("Logo")
        
    }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
