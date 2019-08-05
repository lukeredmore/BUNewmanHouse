//
//  AboutViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

///Downloads, parses, and displays all the events from Breeze. Alert system controlled by cell itself and NotificationController, not here
class EventsViewController: UIViewController, PendingNotificationDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingSymbol: UIActivityIndicatorView!
    
    var dateTimeFormatter : DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fmt
    }
    var eventsArray : [[EventsModel]] = []
    var queuedNotificationIDList : [String] = []
    
    
    //MARK: View Control
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        loadingSymbol.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingSymbol.style = .large
        } else {
            loadingSymbol.style = .whiteLarge
            loadingSymbol.color = .gray
        }
        requestEventsData()
    }
    
    
    //MARK: Data Methods
    func requestEventsData() {
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
                    self.parseEventsData(forJSON: JSON(data!))
                    self.setupTable()
                } else if error != nil {
                    print(error!)
                }
            }
            loadingSymbol.startAnimating()
            task.resume()
        }
        
    }
    func parseEventsData(forJSON json : JSON) {
        eventsArray.removeAll()
        var monthToBeat = dateTimeFormatter.date(from: "\(json[0]["start_datetime"])")?.monthYearString()
        var i = 0
        var loopEnabled = true
        while i < json.count {
            var eventsArrayToAppend : [EventsModel] = []
            while ((dateTimeFormatter.date(from: "\(json[i]["start_datetime"])")?.monthYearString())! == monthToBeat) && loopEnabled {
                let title = "\(json[i]["name"])"
                let startTime = dateTimeFormatter.date(from: "\(json[i]["start_datetime"])")
                let endTime = dateTimeFormatter.date(from: "\(json[i]["end_datetime"])")
                let id = "\(json[i]["id"])"
                eventsArrayToAppend.append(EventsModel(title: title, startTime: startTime, endTime: endTime, id: id))
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
        
        print(eventsArray)
    }
    
    
    //MARK: Alert Methods
    func configureAlerts(forIDList : [String]) {
        self.queuedNotificationIDList = forIDList
        for id in forIDList {
            var markForDeletion = true
            for month in eventsArray {
                for event in month {
                    if id == event.id {
                        markForDeletion = false
                    }
                }
                
            }
            if markForDeletion {
                NotificationController().removeNotification(withID: id)
            }
            
        }
        DispatchQueue.main.async() {
            self.tableView.reloadData()
        }
        
    }
    
    
    //MARK: TableView Methods
    func setupTable() {
        NotificationController().getPendingEventsNotifications(delegate: self)
        DispatchQueue.main.async {
            self.loadingSymbol.stopAnimating()
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventsArray[section][0].startTime?.monthYearString()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventsArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventsTableViewCell") as? EventsTableViewCell else { return UITableViewCell() }
        let model = eventsArray[indexPath.section][indexPath.row]
        cell.addDataForEventsModel(model)
        cell.notificationButton.isSelected = queuedNotificationIDList.contains(model.id)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: "Gotham-Bold", size: 18)
    }
    
}


