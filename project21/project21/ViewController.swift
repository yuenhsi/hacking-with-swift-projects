//
//  ViewController.swift
//  project21
//
//  Created by Yuen Hsi Chang on 12/30/16.
//  Copyright © 2016 Yuen Hsi Chang. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("yay!")
            } else {
                print("aww")
            }
        }
    }
    
    func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "body"
        content.categoryIdentifier = "identifier"
        content.userInfo = ["key": "value"]
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let show = UNNotificationAction(identifier: "show", title: "tell me more..", options: .foreground)
        let category = UNNotificationCategory(identifier: "identifier", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["key"] as? String {
            print("custom data: \(customData)")
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("default identifier")
            case "value":
                print("show more info")
            default:
                break
            }
        }
        completionHandler()
    }
}

