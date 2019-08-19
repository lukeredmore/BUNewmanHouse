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
            print(" ")
            print("Here are the pending notification requests:")
            for request in requests {
                print("\(request.content.title) with ID: ", request.identifier)
                idList.append(request.identifier)
            }
            print("end of requests, sending base values of id's (without -1440 etc. to handler")
            print(" ")
            
            let idSet : Set<String> = Set(idList.map {
                return $0.components(separatedBy: "-")[0]
            })
            
            delegate.configureAlerts(forIDList: idSet.sorted())
        })
        
    }
    
    func addNotification(title: String, body: String, date: Date, id: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let alertTimes = UserDefaults.standard.array(forKey: "eventAlertTimes") as? [Int] ?? [30]
        
        for time in alertTimes {
            //WHEN
            let halfHourPriorDate = Calendar.current.date(byAdding: .minute, value: -time, to: date)
            let dateComponents = Calendar.current.dateComponents([.hour, .year, .minute, .day, .calendar, .second], from: halfHourPriorDate!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            //REQUEST
            let request = UNNotificationRequest(identifier: "\(id)-\(time)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func addWeeklyNotification(forMassModel model: MassDataModel) {
        let content = UNMutableNotificationContent()
        content.title = model.title
        content.body = "Mass begins soon!"
        content.sound = UNNotificationSound.default
        
        let alertTimes = UserDefaults.standard.array(forKey: "eventAlertTimes") as? [Int] ?? [30]
        
        for time in alertTimes {
            var dateComponents = DateComponents()
            dateComponents.hour = model.hour
            dateComponents.minute = model.minute - time
            dateComponents.weekday = model.weekday
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
            let request = UNNotificationRequest(identifier: "\(model.id)-\(time)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        }
        
        
    }
    
    func removeNotification(withID id: String) {
        print("removing notification with id: \(id)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(id)", "\(id)-0", "\(id)-5", "\(id)-15", "\(id)-30", "\(id)-60", "\(id)-120", "\(id)-1440", "\(id)-2880", "\(id)-10080"])
    }
}

