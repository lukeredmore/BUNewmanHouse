//
//  NotificationController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/28/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import Foundation
import UserNotifications

protocol PendingNotificationDelegate: class {
    func configureAlerts(forIDList : [String])
}

class NotificationController {
    
    func getPendingEventsNotifications(delegate : PendingNotificationDelegate) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            var idList : [String] = []
            print("\nHere are the pending notification requests:")
            for request in requests {
                print(request)
                idList.append(request.identifier)
            }
            print("end of requests\n")
            delegate.configureAlerts(forIDList: idList)
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
    
    func addWeeklyNotification(model: MassDataModel) {
        let content = UNMutableNotificationContent()
        content.title = model.title
        content.body = "Mass begins in 30 minutes!"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = model.hour
        dateComponents.minute = model.minute
        dateComponents.weekday = model.weekday
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: model.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func removeNotification(withID id: String) {
       print("removing notification with id: \(id)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

