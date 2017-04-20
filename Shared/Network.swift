//
//  network.swift
//  FieldGuide
//
//  Created by Amartya Banerjee on 4/19/17.
//  Copyright © 2017 SESP Walkup. All rights reserved.
//

import Foundation

public enum hostType: String{
    case localhost = "http://127.0.0.1:8000/"
    case remote = "http://digitalrail.xyz/"
}

class NetworkManager{
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager(host: hostType.remote.rawValue)
        
        return networkManager
    }()
    
    let host: String
    var displayStory: Bool
    
    private init(host: String){
        self.host = host
        self.displayStory = false
    }
    
    class func shared() -> NetworkManager{
        return sharedNetworkManager
    }
    
    func createAndSendRequest(path: String, params: Dictionary<String, String>){
        var request = URLRequest(url: URL(string: self.host + path)!)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        catch{
            print("error serializing data")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as! NSDictionary
                
                if (json.object(forKey: "displaystory") != nil){
                    self.displayStory = json.object(forKey: "displaystory")! as! Bool
                }
                
            }
            catch {
                //Handle error
            }
        }
        task.resume()
    }
}
