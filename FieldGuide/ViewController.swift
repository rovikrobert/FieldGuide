//
//  ViewController.swift
//  FieldGuide
//
//  Created by SESP Walkup on 2/23/17.
//  Copyright © 2017 SESP Walkup. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    var networkRequest: NetworkRequest = NetworkRequest.init()
    
    @IBOutlet var serverToggle: UISwitch!
    
    @IBAction func selectTargetServer(_ sender:UISwitch){
        var requestValues = ["network" : "local", "command" : "hostchange"]
        let session = WCSession.default()
        
        if(sender.isOn){
            NetworkSetting.shared().host = hostType.remote.rawValue
            requestValues["network"] = "remote"
            
        }
        else{
            NetworkSetting.shared().host = hostType.localhost.rawValue
            requestValues["network"] = "local"
        }
        
        if WCSession.default().isReachable == true {
            session.sendMessage(requestValues, replyHandler: { reply in
                print("sent message")
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }
    }
    
    @IBAction func arriveAtExhibit(_ sender: UIButton) {
        if WCSession.default().isReachable == true {
            let requestValues = ["command" : "Exhibit"]
            let session = WCSession.default()
            
            session.sendMessage(requestValues, replyHandler: { reply in
                print("sent message")
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }
    }

    @IBAction func arriveAtRail(_ sender: UIButton) {
        setWatchFlag()
        
        if WCSession.default().isReachable == true {
            let requestValues = ["command" : "Rail"]
            let session = WCSession.default()
            
            session.sendMessage(requestValues, replyHandler: { reply in
                print("sent message")
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }
    }

    @IBAction func toggleRailArea(_ sender: Any) {
        setWatchFlag()
    }
    
    @IBAction func collectInformation(_ sender: UIButton) {
        if WCSession.default().isReachable == true {
            let requestValues = ["command" : "Collect"]
            let session = WCSession.default()
            
            session.sendMessage(requestValues, replyHandler: { reply in
                print("sent message")
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }
    }
    
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    func sessionDidBecomeInactive(_ session: WCSession){
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //sets the flag to show/hide the watch area on the digital rail
    func setWatchFlag() {
        let params = ["name": "ios"] as Dictionary<String, String>
        networkRequest.createAndSendRequest(path: "setwatchstatus/", params: params)
    }
    
    func timerAction(_ timer: Timer){
        let params = ["name": "ios"] as Dictionary<String, String>
        
        if(networkRequest.requestReturnStatus){
            print("sending another request")
            networkRequest.createAndSendRequest(path: "getdisplaystory/", params: params)
        }
        
        if(networkRequest.displayStory){
            if WCSession.default().isReachable == true {
                let requestValues = ["command" : "Connect"]
                let session = WCSession.default()
                
                session.sendMessage(requestValues, replyHandler: { reply in
                    print("sent message")
                }, errorHandler: { error in
                    print("error: \(error)")
                })
            }
        }
    }
}

