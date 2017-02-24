//
//  Prompt.swift
//  FieldGuide
//
//  Created by Rovik Robert on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit

class Prompt {
  
    let area : String
    let header: String
    let promptText: String
    private let item: String
    let itemImg: Image

  
  class func allPrompts() -> [Prompt] {
    var prompts = [Prompt]()
    if let path = Bundle.main.path(forResource: "Prompts", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [Dictionary<String, String>]
        for dict in json {
          let prompt = Prompt(dictionary: dict)
          prompts.append(prompt)
        }
      } catch {
        print(error)
      }
    }
    return prompts
  }
  
    init(area: String, header: String, promptText: String, item: String) {
    self.area = area
    self.header = header
    self.promptText = promptText
    self.item = item
    self.itemImg = getImage(item)
  }
  
  convenience init(dictionary: [String: String]) {
    let area = dictionary["area"]!
    let header = dictionary["header"]!
    let promptText = dictionary["promptText"]!
    let item = dictionary["item"]!
    self.init(area: area, header: header, promptText: promptText, item: item)
  }

    func getImage(item: String){
        if let item = "Map"{
         return #imageLiteral(resourceName: "Logo")
    }
  
}
}
