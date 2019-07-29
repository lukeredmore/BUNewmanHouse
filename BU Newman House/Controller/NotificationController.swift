//
//  NotificationController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/28/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationController {
    
    func getPendingEventsNotifications(caller : EventsViewController) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            var idList : [String] = []
            print("\nHere are the pending notification requests:")
            for request in requests {
                print(request)
                idList.append(request.identifier)
            }
            print("end of requests\n")
            caller.configureAlerts(forIDList: idList)
        })
        
    }
    
    func addNotification(title: String, body: String, date: Date, id: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        //WHEN
        let halfHourPriorDate = Calendar.current.date(byAdding: .minute, value: -30, to: date)
        let dateComponents = Calendar.current.dateComponents([.hour, .year, .minute, .day, .calendar, .second], from: halfHourPriorDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //REQUEST
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        //                print("Today is \(date). Today is \(notificationContent).")
    }
    
    func removeNotification(withID id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

