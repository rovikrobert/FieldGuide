//
//  PromptInterfaceController.swift
//  FieldGuide
//
//  Created by SESP Walkup on 2/24/17.
//  Copyright © 2017 SESP Walkup. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class PromptInterfaceController: WKInterfaceController, WCSessionDelegate {
   
    override func awake (withContext: Any?) {
        super.awake(withContext: withContext)
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        if let prompt = withContext as? Prompt { self.prompt = prompt }
    }
    
    @IBOutlet var Header: WKInterfaceLabel!
    @IBOutlet var ItemImage: WKInterfaceImage!
    @IBOutlet var Area: WKInterfaceLabel!
    
    @IBOutlet var PromptText: WKInterfaceLabel!
    
    @IBAction func goToCompass() {
        self.presentController(withName: "GuideCaseNum", context: self.prompt)
        //self.presentController(withName: "GuideCaseLogo", context: self.prompt)
    }
    
    var prompt: Prompt? {
        didSet {
            if let prompt = prompt {
                Header.setText(prompt.header)
                Area.setText(prompt.area)
                PromptText.setText(prompt.promptText)
                //ItemImage.setImage(UIImage(named: prompt.itemImgName))
                ItemImage.setImageNamed(prompt.itemImgName)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var replyValues = Dictionary<String, Any>()
        
        
        switch message["command"] as! String {
        case "CancelOptions" :
            replyValues["status"] = "Dismissed"
            self.dismiss()
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
    }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
