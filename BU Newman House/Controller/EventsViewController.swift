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

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingSymbol: UIActivityIndicatorView!
    
    var dateTimeFormatter : DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fmt
    }
    var eventsArray : [[EventsModel]] = []
    var queuedNotificationIDList : [String] = []
    
    
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
        getSampleJSONData() //requestEventsData()
    }
    
    
    //MARK: Data Methods
    func requestEventsData() { //TODO: Add Newman API key
        if let url = URL(string: "https://newman.breezechms.com/api/events") {
            let request = NSMutableURLRequest(url: url)
            request.setValue("KEY", forHTTPHeaderField: "X-Mashape-Key")
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if (response as? HTTPURLResponse) != nil {
                    self.parseEventsData(forJSON: JSON(data!))
                    self.setupTable()
                }
            }
            loadingSymbol.startAnimating()
            task.resume()
        }
        
    }
    func parseEventsData(forJSON : JSON) {
        eventsArray.removeAll()
        var monthToBeat = dateTimeFormatter.date(from: "\(forJSON["data"][0]["start_datetime"])")?.monthYearString()
        var i = 0
        var loopEnabled = true
        while i < forJSON["data"].count {
            var eventsArrayToAppend : [EventsModel] = []
            while ((dateTimeFormatter.date(from: "\(forJSON["data"][i]["start_datetime"])")?.monthYearString())! == monthToBeat) && loopEnabled {
                let title = "\(forJSON["data"][i]["name"])"
                let startTime = dateTimeFormatter.date(from: "\(forJSON["data"][i]["start_datetime"])")
                let endTime = dateTimeFormatter.date(from: "\(forJSON["data"][i]["end_datetime"])")
                let id = "\(forJSON["data"][i]["id"])"
                eventsArrayToAppend.append(EventsModel(title: title, startTime: startTime, endTime: endTime, id: id))
                if i < forJSON["data"].count - 1 {
                    i += 1
                } else {
                    loopEnabled = false
                }
                
            }
            eventsArray.append(eventsArrayToAppend)
            monthToBeat = dateTimeFormatter.date(from: "\(forJSON["data"][i]["start_datetime"])")?.monthYearString()
            if !loopEnabled {
                i = forJSON["data"].count
            }
        }
        
        print(eventsArray)
    }
    func getSampleJSONData() {
        if let path = Bundle.main.path(forResource: "sampleJSON", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                parseEventsData(forJSON: jsonObj)
                setupTable()
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
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
        NotificationController().getPendingEventsNotifications(caller: self)
        loadingSymbol.stopAnimating()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
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


