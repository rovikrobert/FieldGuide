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
   
    @IBOutlet var ItemImage: WKInterfaceImage!
    @IBOutlet var Area: WKInterfaceLabel!
    
    @IBOutlet var PromptText: WKInterfaceLabel!
    
    @IBAction func navigateToItem() {
    }
    
    var prompts = Prompt.allPrompts()
    
    
    var prompt: Prompt? {
        didSet {
            if let prompt = prompt {
                Area.setText(prompt.area)
                PromptText.setText(prompt.promptText)
                ItemImage.setImage(prompt.itemImg)
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        var promptcount = prompts.count
        
        NSMutableArray *controllersNames = [NSMutableArray arrayWithCapacity:pageCount]
        NSMutableArray *controllersContexts = [NSMutableArray arrayWithCapacity:pageCount];
        if (pageCount) {
            for (uint8_t i = 0; i < pageCount; i++) {
                [controllersNames addObject:@"page"];
                [controllersContexts addObject:@[self, @(i)]];
            }
        }
        else {
            // no pages controller
            [controllersNames addObject:@"nopage"];
            [controllersContexts addObject:@[self, @(0)]];
        }
        
        // reload base controller
        [WKInterfaceController reloadRootControllersWithNames:controllersNames contexts:controllersContexts];
        
    }
    
    internal func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
