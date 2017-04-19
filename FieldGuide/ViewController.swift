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

    @IBOutlet weak var RailStatus: UILabel!
    @IBOutlet weak var ExhibitStatus: UILabel!
    @IBOutlet weak var CollectStatus: UILabel!
    @IBOutlet weak var ConnectStatus: UILabel!
    
    @IBAction func arriveAtExhibit(_ sender: UIButton) {
        if WCSession.default().isReachable == true {
            let requestValues = ["command" : "Exhibit"]
            let session = WCSession.default()
            
            session.sendMessage(requestValues, replyHandler: { reply in
                self.ExhibitStatus.text = reply["status"] as? String
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
                self.RailStatus.text = reply["status"] as? String
            }, errorHandler: { error in
                print("error: \(error)")
            })
        }
    }
    
    @IBAction func connectToRail(_ sender: UIButton) {
        if WCSession.default().isReachable == true {
            let requestValues = ["command" : "Connect"]
            let session = WCSession.default()
            
            session.sendMessage(requestValues, replyHandler: { reply in
                self.ConnectStatus.text = reply["status"] as? String
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
                self.CollectStatus.text = reply["status"] as? String
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
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        RailStatus.text = ""
        ExhibitStatus.text = ""
        CollectStatus.text = ""
        ConnectStatus.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //sets the flag to show/hide the watch area on the digital rail
    func setWatchFlag() {
        //var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/setwatchstatus/")!)
        var request = URLRequest(url: URL(string: "http://digitalrail.xyz/setwatchstatus/")!)
        request.httpMethod = "POST"
        
        let params = ["name": "ios"] as Dictionary<String, String>
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        catch{
            print("error serializing data")
        }
        
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

