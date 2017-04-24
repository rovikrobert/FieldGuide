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
    
    @IBOutlet var promptText: WKInterfaceLabel!
    @IBOutlet var railImg: WKInterfaceImage!
    
    var networkRequest: NetworkRequest = NetworkRequest.init()
    
    var prompt: Prompt? {
        didSet {
            if let prompt = prompt {
                promptText.setText(prompt.promptText)
                railImg.setImageNamed("animation")
                railImg.startAnimating()
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

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        switch message["command"] as! String {
        
        case "Connect" :
            self.presentController(withNames: ["ConnectedScreen"], contexts: nil)
            WKInterfaceDevice.current().play(.notification)
            WKInterfaceDevice.current().play(.notification)
        
        case "Exhibit" :
            self.dismiss()
            WKInterfaceDevice.current().play(.notification)
        
        //hostchange handles the toggle between localhost & remote servers
        case "hostchange":
            let networkSetting = message as Dictionary
            let setting = networkSetting["network"] as! String
            
            if(setting == "remote"){
                NetworkSetting.shared().host = hostType.remote.rawValue
            }
            else{
                NetworkSetting.shared().host = hostType.localhost.rawValue
            }
        default:
            break
        }
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
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func connectToRail() {
        showStoryOnRail()
        
        self.presentController(withName: "ConnectedScreen", context: nil)
        WKInterfaceDevice.current().play(.notification)
    }
    
    func showStoryOnRail() {
        let params = ["name": "watch"] as Dictionary<String, String>
        networkRequest.createAndSendRequest(path: "setdisplaystory/", params: params)
    }
}
