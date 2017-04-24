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
    var watchAreaRequest: NetworkRequest = NetworkRequest.init()
    var saveDataRequest: NetworkRequest = NetworkRequest.init()
    
    var watchAreaTimer: Timer = Timer.init()
    var saveDataTimer: Timer = Timer.init()
    
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

    @IBAction func resetRail(_ sender: Any) {
        setWatchFlag()
        watchAreaTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        if WCSession.default().isReachable == true {
            let requestValues = ["command" : "Reset"]
            let session = WCSession.default()
            
            session.sendMessage(requestValues, replyHandler: { reply in
                print("sent message")
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }
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
        watchAreaTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        saveDataTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerSaveAction), userInfo: nil, repeats: true)
        
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
        watchAreaRequest.createAndSendRequest(path: "setwatchstatus/", params: params)
    }
    
    //checks to see if the visitor tapped the digital rail to read a story
    func timerAction(_ timer: Timer){
        let params = ["name": "ios"] as Dictionary<String, String>
        
        if(watchAreaRequest.requestReturnStatus){
            watchAreaRequest.createAndSendRequest(path: "getdisplaystory/", params: params)
        }
        
        if(watchAreaRequest.returnVal.object(forKey: "displaystory") != nil){
            if(watchAreaRequest.returnVal.object(forKey: "displaystory") as! Bool){
                if WCSession.default().isReachable == true {
                    let requestValues = ["command" : "Connect"]
                    let session = WCSession.default()
                    
                    session.sendMessage(requestValues, replyHandler: { reply in
                        print("sent message")
                    }, errorHandler: { error in
                        print("error: \(error)")
                    })
                }
                
                //stop polling for database changes after sending message to watch
                watchAreaTimer.invalidate()
            }
        }
    }
    
    
    //checks to see if the visitor saved a story
    func timerSaveAction(_ timer: Timer){
        let params = ["name": "ios"] as Dictionary<String, String>
        
        if(saveDataRequest.requestReturnStatus){
            if(saveDataRequest.prevReturnVal.object(forKey: "id") != nil && saveDataRequest.returnVal.object(forKey: "id") != nil){
                let prevVal = saveDataRequest.prevReturnVal.object(forKey: "id") as! Int
                let currVal = saveDataRequest.returnVal.object(forKey: "id") as! Int

                if(prevVal != currVal){
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
            }
            saveDataRequest.createAndSendRequest(path: "getsavedata/", params: params)
        }
    }
}

