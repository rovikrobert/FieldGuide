//
//  network.swift
//  FieldGuide
//
//  Created by Amartya Banerjee on 4/19/17.

import Foundation

public enum hostType: String{
    case localhost = "http://127.0.0.1:8000/"
    case remote = "http://digitalrail.xyz/"
}

class NetworkSetting{
    private static var sharedNetworkSetting: NetworkSetting = {
        let networkManager = NetworkSetting(host: hostType.localhost.rawValue)
        return networkManager
    }()
    
    let host: String

    private init(host: String){
        self.host = host
    }
    
    class func shared() -> NetworkSetting{
        return sharedNetworkSetting
    }
}

class NetworkRequest{
    var displayStory: Bool
    
    init(){
        self.displayStory = false
    }
    
    func createAndSendRequest(path: String, params: Dictionary<String, String>){
        var request = URLRequest(url: URL(string:  NetworkSetting.shared().host + path)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
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
