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
            //session.activate()
        }
        if let prompt = withContext as? Prompt { self.prompt = prompt }
    }
    
    @IBOutlet var Header: WKInterfaceLabel!
    @IBOutlet var ItemImage: WKInterfaceImage!
    @IBOutlet var Area: WKInterfaceLabel!
    
    @IBOutlet var PromptText: WKInterfaceLabel!
    
    var networkRequest: NetworkRequest = NetworkRequest.init()
    
    var prompt: Prompt? {
        didSet {
            if let prompt = prompt {
                Header.setText(prompt.header)
                //Area.setText(prompt.area)
                PromptText.setText(prompt.promptText)
                //ItemImage.setImage(UIImage(named: prompt.itemImgName))
                ItemImage.setImageNamed(prompt.itemImgName)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        switch message["command"] as! String {
            case "Reset":
                self.presentController(withName: "Museum", context: nil)
            default:
                break
        }
        
        let networkSetting = message as Dictionary
        guard let setting = networkSetting["network"] else{
            print("network settings not updated")
            return
        }
        if(setting as! String  == "remote"){
            NetworkSetting.shared().host = hostType.remote.rawValue
        }
        else{
            NetworkSetting.shared().host = hostType.localhost.rawValue
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
    
    //posts the story id to the digital rail server when the user clicks
    @IBAction func setStoryId() {
        let params = ["name": "watch", "promptId": prompt!.itemID] as Dictionary<String, String>
        networkRequest.createAndSendRequest(path: "setwatchstory/", params: params)
        presentController(withName: "GuideCaseNum", context: self.prompt)
    }
}
