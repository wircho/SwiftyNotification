//
//  ViewController.swift
//  SwiftyNotificationSample
//
//  Created by AdolfoX Rodriguez on 2016-06-01.
//  Copyright © 2016 Mokriya. All rights reserved.
//

import UIKit

// MARK: Preparation

// Keyboard Appeared Notification
final class KeyboardAppeared: Notification {
    static let name = UIKeyboardDidShowNotification
    static func parameters(note: NSNotification) throws -> (beginFrame:CGRect,endFrame:CGRect) {
        let beginFrame = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectNull
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectNull
        return (beginFrame,endFrame)
    }
}

// Keyboard Disappeared Notification
final class KeyboardDisappeared: Notification {
    static let name = UIKeyboardDidHideNotification
    static func parameters(note: NSNotification) throws -> (beginFrame:CGRect,endFrame:CGRect) {
        let beginFrame = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectNull
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectNull
        return (beginFrame,endFrame)
    }
}

class ViewController: UIViewController {

    // MARK: IBOutlets & IBActions
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dismissKeyboardButton: UIButton!
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registering as observer
        // No need to unregister, since that will happen
        // once the view controller gets released
        
        dismissKeyboardButton.enabled = false
        
        KeyboardAppeared.register(self) {
            innerSelf,params in
            
            innerSelf.label.text = "Keyboard Appeared\nFrom \(params.beginFrame)\nTo \(params.endFrame)"
            innerSelf.dismissKeyboardButton.enabled = true
        }
        
        KeyboardDisappeared.register(self) {
            innerSelf,params in
            
            innerSelf.label.text = "Keyboard Disappeared\nFrom \(params.beginFrame)\nTo \(params.endFrame)"
            innerSelf.dismissKeyboardButton.enabled = false
        }
    }
}

