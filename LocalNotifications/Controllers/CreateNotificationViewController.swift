//
//  CreateNotificationViewController.swift
//  LocalNotifications
//
//  Created by Melinda Diaz on 2/20/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
//step 1 custom delegate (protocol)
protocol CreateNotificationControllerDelegate: AnyObject {
    func didCreateNotification(_ createNotificationController: CreateNotificationViewController)
}
class CreateNotificationViewController: UIViewController {
    //step 2 custom delegation
    weak var delegate: CreateNotificationControllerDelegate?
    //time can be represented by the seconds from 1970 its a standardized unix time
    //if they dont use the date picker and we use nil it will crash so setting a value will stop it from crashing and when the user DOES use the date picker it will override the #5
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow + 5
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func createLocalNotification() {//OVERVIEW 12:18
        //step1: create the content WHat is the content of theta notificatiom
        //mutable you can change that content therer is mutable and immutable so this is how we change the content TIME 12pm
        let content = UNMutableNotificationContent()
        content.title = titleTextField.text ?? "No title"
        content.body = "Local Notifications is awesome when used appropriately"
        content.subtitle = "Learning Local Notifications"
        content.sound = .default //only works in the background and the app is not on silent - pleae test on devise
        //TODO: you can also import your own sound file similar to adding the file for the leo.
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "yourfile.mp3"))//you can use .m4g .ppg files to
        
        //TODO: userINfo dictionarty can hold additional data
        // content.attachments = [attachment]
        //create indentifier we need an ID for every notification. we always get a new ID everytime we get a notification
        let identifier = UUID().uuidString // unique string
        //attachment we are trying to have an attachment to the identifier. we added a photo to the attachment
        if let imageURL = Bundle.main.url(forResource: "Leo-PNG-Transparent-Picture", withExtension: "png"){
            do {
                //we use a bundle file in order to attach it but right now we are getting an errror that UNNOtifications THROWS so we have to take it an put it in a doCatch //TIME 12:12
                let attachment = try UNNotificationAttachment(identifier: identifier , url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
                print("error with attachment: \(error)")
            }
        } else {
            print("image resources ")
        }
        //create a trigger, 3 possible triggers for local notifications: time interval, calendar
        //what triggers local time or calendar?
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        //create a request takes in an ID what notification
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        //then we hand it to the notification center and now its pending
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error adding request: \(error)")
            } else {
                print("request was successfully added")
            }
        }
    }
    @IBAction func datePickerChange(_ sender: UIDatePicker) {
        //to avoid time being in the past
        guard sender.date > Date() else { return }
        //timeIntervalSinceNow creates a time stanp of the exact date
        timeInterval = sender.date.timeIntervalSinceNow
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        createLocalNotification()
        //step 3 custom delegate
        delegate?.didCreateNotification(self)
        dismiss(animated: true)
    }
}
