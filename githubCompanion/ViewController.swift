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
    
    func convertDate(date: String) -> String {
        /* Create dateFormatter with UTC time format */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateFormatted = dateFormatter.date(from: date)// create date from string
        
        /* Convert to local timezone and format to remove time */
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateFormatted = dateFormatted {
            let timeStamp = dateFormatter.string(from: dateFormatted)
            return timeStamp
        }
        return "incorrect Date"
    }
    
    @IBAction func goButton(_ sender: Any) {
        /* Create date and date formatter objects */
        let date = Date()
        let formatter = DateFormatter()
        /* Set date format to the same as response from API */
        formatter.dateFormat = "yyyy-MM-dd"
        
        /* Create network instance */
        let network = Networking()
        network.getEvents(resource: .users(username: nameTextField.text!)) { (res) in
            /* Save the events received to the events array */
            self.events = res
            
            /* Create var to note when the latest push event was */
            var eventDate = ""
            for event in self.events {
                if let typeEvent = event.type {
                    if typeEvent == "PushEvent" {
                        if let date = event.date {
                            let index = date.index(date.startIndex, offsetBy: 19)
                            eventDate = date.substring(to: index)
                        }
                        break  // Break out of for loop after finding a push event
                    }
                }
                
            }
            /* Convert date to current timezone */
            eventDate = self.convertDate(date: eventDate)
            print(eventDate)
            
            
            /* Use formatter to create the current date */
            let currentDate = formatter.string(from: date)
            
            /* Configure Alert to let user know if they made commit and add dismiss action */
            var alert = UIAlertController(title: "Commit Soon!", message: "You haven't made a commit today! Get on it!", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: {
                (alertAction: UIAlertAction!) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            /* Compare current date and tomorrow's date to the event date */
            if currentDate == eventDate {
                alert.title = "WOOOOOO"
                alert.message = "You made a commit today! Good Job!"
            }
            
            /* Show the alert */
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

