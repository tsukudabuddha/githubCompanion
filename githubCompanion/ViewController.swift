//
//  ViewController.swift
//  githubCompanion
//
//  Created by Andrew Tsukuda on 11/7/17.
//  Copyright © 2017 Andrew Tsukuda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var events: [Event] = []
    
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func goButton(_ sender: Any) {
        // Create date and date formatter objects
        let date = Date()
        let formatter = DateFormatter()
        
        // Create network instance
        let network = Networking()
        network.getEvents(resource: .users(username: nameTextField.text!)) { (res) in
            self.events = res
            
            var finalDate = ""
            
            for event in self.events {
                if let typeEvent = event.type {
                    if typeEvent == "PushEvent" {
                        if let date = event.date {
                            for char in date {
                                if char == "T" {
                                    break
                                } else {
                                    finalDate += String(describing: char)
                                }
                            }
                        }
                        break  // Break out of for loop after finding a push event
                    }
                }
                
            }
            formatter.dateFormat = "yyyy-MM-dd"
            let currentDate = formatter.string(from: date)
            
            
            var alert = UIAlertController(title: "Commit Soon!", message: "You haven't made a commit today! Get on it!", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: {
                (alertAction: UIAlertAction!) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            if currentDate == finalDate {
                alert.title = "WOOOOOO"
                alert.message = "You made a commit today! Good Job!"
            }
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            
            
            
        } // MARK: End of completion callback
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

/* method to check if string is alphanumeric*/
extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

