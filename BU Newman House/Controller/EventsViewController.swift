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

class EventsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingSymbol: UIActivityIndicatorView!
    
    var dateTimeFormatter : DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fmt
    }
    var eventsArray : [EventsModel] = []
    
    
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
        for n in 0..<forJSON["data"].count {
            let title = "\(forJSON["data"][n]["name"])"
            let startTime = dateTimeFormatter.date(from: "\(forJSON["data"][n]["start_datetime"])")
            let endTime = dateTimeFormatter.date(from: "\(forJSON["data"][n]["end_datetime"])")
            let id = "\(forJSON["data"][n]["id"])"
            eventsArray.append(EventsModel(title: title, startTime: startTime, endTime: endTime, id: id))
        }
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
    
    
    //MARK: TableView Methods
    func setupTable() {
        loadingSymbol.stopAnimating()
        tableView.dataSource = self
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventsTableViewCell") as? EventsTableViewCell {
            cell.addDataForEventsModel(eventsArray[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    
}


