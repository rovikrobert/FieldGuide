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
    
    //posts the story id to the digital rail server when the user clicks
    @IBAction func setStoryId() {
        //var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/setwatchstory/")!)
        var request = URLRequest(url: URL(string: "http://digitalrail.xyz/setwatchstory/")!)
        
        request.httpMethod = "POST"
        let params = ["name": "watch", "promptId": prompt!.itemID] as Dictionary<String, String>
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        catch{
            print("error serializing data")
        }
        
        self.presentController(withName: "GuideCaseNum", context: self.prompt)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
}
