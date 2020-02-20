//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Melinda Diaz on 2/20/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
import UserNotifications
//you must import User Notifications
class NotificationsViewController: UIViewController {
    //make sure explicitly unwrap your tableview
    @IBOutlet weak var tableView: UITableView!
    //notification singleton
    private var notifications = [UNNotificationRequest](){
        didSet {
            //12:42pm
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let center = UNUserNotificationCenter.current()
    //here we have a instance from the class file
    private let pendingNotification = PendingNotification()
    private var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        configureRefreshControl()
        checkNotificationAuthorization()
        loadNotifications()
        //setting this view controller as the delegate object for thae UNNotificationCenterDelegate
        center.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let navController = segue .destination as? UINavigationController,
            let createVC = navController.viewControllers.first as? CreateNotificationViewController else {
                fatalError("could not downcast to createViewController")
        }
        //Compiler ERROR:Cannot assign value of type 'NotificationsViewController' to type 'CreateNotificationControllerDelegate?'
        //so you need the extension CreateNBotificatioonDelegate
        createVC.delegate = self
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
    }
    //11:35am
    @objc private func loadNotifications() {
        pendingNotification.getPendingNotifications { (requests) in
            self.notifications = requests
            //stop the refresh control from animating and remove from the UI
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    //do we have access to notifications am i authorized?? this gives us the alert asking If would like to Send you Notifications and it only pops up once
    private func checkNotificationAuthorization() {//the settings var will give us information if we are authorized
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("app is authorized for notifications")
            } else {
                //if we will prone the user for permission this is necessary
                self.requestNotificationPermissions()
            }
        }
    }
    
    //If not authorized call here, we need permission or else it does not work
    private func requestNotificationPermissions(){
        //so we are asking for permission for alert or some sound play some default sound when the alert comes up,
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("error request Authorization: \(error)")
                return
            }
            if granted {
                print("access was granted")
            } else {
                print("access was denied")
            }
        }
    }
    
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.content.body
        cell.detailTextLabel?.text = notification.content.body
        return cell
    }
    //this listen to the swipes
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editing style == .delete
    }
    
}

extension NotificationsViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
extension NotificationsViewController: CreateNotificationControllerDelegate {
    func didCreateNotification(_ createNotificationController: CreateNotificationViewController) {
        loadNotifications()
    }
}
