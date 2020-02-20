//
//  PendingNotification.swift
//  LocalNotifications
//
//  Created by Melinda Diaz on 2/20/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification {
    
    public func getPendingNotifications(completion: @ escaping ([UNNotificationRequest]) -> ()) {
        //user notifications get us all the pending request
        //this will trun the data that we need and will be the data that powers our table view.
        //a request is being sent out today later or pending and there is no failure here because we got permission earlier
        //the reason why we wrote this in a separatre class because all you would have to do is query the one class for it. 
        UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
            print("There are \(request.count) pending requests.")
            completion(request)
        }
    }
}
