//
//  EventsRetriever.swift
//  BU Newman House
//
//  Created by Luke Redmore on 8/11/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventsRetriever: NSObject, PendingNotificationDelegate {
    func configureAlerts(forIDList idList: [String]) {
        getEventsDataFromOnline(forIDList : idList)
    }
    
    
    var dateTimeFormatter : DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fmt
    }
    
    let notificationController = NotificationController()
    let preferences = UserDefaults.standard
    let completion : ([[EventsModel]]?) -> Void
    
    init(completion : @escaping ([[EventsModel]]?) -> Void) {
        self.completion = completion
        
    }
    
    func retrieveEventsArray(forceReturn : Bool = false, forceRefresh: Bool = false) {
        if forceRefresh {
            print("Events Data is being force refreshed")
            notificationController.getPendingEventsNotifications(delegate: self)
        } else if forceReturn {
            print("Events Data is being force returned")
            if let json = preferences.value(forKey:"eventsArray") as? Data {
                print("Force return found an old JSON value")
                let optionalModel = try? PropertyListDecoder().decode([[EventsModel]].self, from: json)
                return completion(optionalModel)
            } else {
                print("Force return returned an empty array")
                return completion(nil)
            }
        } else {
            print("Attempting to retrieve stored Events data.")
            if let eventsArrayTimeString = preferences.string(forKey: "eventsArrayTime"),
                let json = preferences.value(forKey:"eventsArray") as? Data { //If both events values are defined
                let eventsArrayTime = eventsArrayTimeString.toDateWithTime()! + 3600 //Time one hour in future
                if eventsArrayTime > Date() {
                    print("Up-to-date Events data found, no need to look online.")
                    return completion(try! PropertyListDecoder().decode([[EventsModel]].self, from: json))
                } else {
                    print("Events data found, but is old. Will refresh online.")
                    notificationController.getPendingEventsNotifications(delegate: self)
                }
            } else {
                print("No Events data found in UserDefaults. Looking online.")
                notificationController.getPendingEventsNotifications(delegate: self)
            }
        }
    }
    private func getEventsDataFromOnline(forIDList idList : [String]) {
        print("We are asking for Events data")
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let endDate = Calendar.current.date(byAdding: DateComponents(year: 1), to: Date())!
        let tag = "?start=\(fmt.string(from: Date()))&end=\(fmt.string(from: endDate))"
        print(tag)
        if let url = URL(string: "https://newman.breezechms.com/api/events\(tag)") {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Content-Type": "application/json","api-key" : PrivateAPIKeys.BREEZE_API_KEY]
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if response as? HTTPURLResponse != nil && data != nil {
                    self.parseEventsData(forJSON: JSON(data!), withIDList: idList)
                    self.retrieveEventsArray()
                } else if error != nil {
                    print("Error on request to Breeze: ")
                    print(error!)
                    self.retrieveEventsArray(forceReturn: true, forceRefresh: false)
                }
            }
            task.resume()
        }
    }
    
    private func parseEventsData(forJSON json : JSON, withIDList idList : [String]) {
        var eventsArray = [[EventsModel]]()
        var monthToBeat = dateTimeFormatter.date(from: "\(json[0]["start_datetime"])")?.monthYearString()
        var i = 0
        var loopEnabled = true
        var mutableIDList = idList
        while i < json.count {
            var eventsArrayToAppend : [EventsModel] = []
            while ((dateTimeFormatter.date(from: "\(json[i]["start_datetime"])")?.monthYearString())! == monthToBeat) && loopEnabled {
                let title = "\(json[i]["name"])"
                let startTime = dateTimeFormatter.date(from: "\(json[i]["start_datetime"])")
                let endTime = dateTimeFormatter.date(from: "\(json[i]["end_datetime"])")
                let id = "\(json[i]["id"])"
                
                
                var shouldNotifyThisEvent = false
                if let idIndex = mutableIDList.firstIndex(of: id) {
                    shouldNotifyThisEvent = true
                    mutableIDList.remove(at: idIndex)
                }
               
               if !title.contains("Mass") {
                    eventsArrayToAppend.append(EventsModel(title: title, startTime: startTime, endTime: endTime, id: id, buttonSelected: shouldNotifyThisEvent))
                }
                if i < json.count - 1 {
                    i += 1
                } else {
                    loopEnabled = false
                }
                
            }
            eventsArray.append(eventsArrayToAppend)
            monthToBeat = dateTimeFormatter.date(from: "\(json[i]["start_datetime"])")?.monthYearString()
            if !loopEnabled {
                i = json.count
            }
            
            
        }
        for unusedID in mutableIDList {
            notificationController.removeNotification(withID: unusedID)
        }
        if eventsArray.count > 0 {
            addObjectArrayToUserDefaults(eventsArray)
        }

    }
    
    func addObjectArrayToUserDefaults(_ eventsArray: [[EventsModel]], updateTime : Bool = true) {
        print("Events array is being added to UserDefaults")
        if updateTime {
            let dateTimeToAdd = Date().dateStringWithTime()
            UserDefaults.standard.set(dateTimeToAdd, forKey: "eventsArrayTime")
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(eventsArray), forKey: "eventsArray")
        
    }
}
