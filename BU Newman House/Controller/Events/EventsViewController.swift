//
//  AboutViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

///Downloads, parses, and displays all the events from Breeze. Alert system controlled by cell itself and NotificationController, not here
class EventsViewController: UIViewController, PendingNotificationDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingSymbol: UIActivityIndicatorView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .gray
        
        return refreshControl
    }()
    
    
    var eventsArray : [[EventsModel]]!
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
        loadingSymbol.startAnimating()
        EventsRetriever().retrieveEventsArray(forceReturn: false, forceRefresh: false, completion: setupTable)
    }
    
    
    //MARK: Data Methods
    @objc func refreshData() {
        EventsRetriever().retrieveEventsArray(forceReturn: false, forceRefresh: true, completion: setupTable)
    }
    
    
    //MARK: Alert Methods
    func configureAlerts(forIDList : [String]) {
        self.queuedNotificationIDList = forIDList
        for id in forIDList {
            var markForDeletion = true
            for month in eventsArray {
                for event in month {
                    if id == event.id || event.id.contains("newman") || event.id.contains("vincent") {
                        markForDeletion = false
                    }
                }
            }
            if markForDeletion {
                NotificationController().removeNotification(withID: id)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    //MARK: TableView Methods
    func setupTable(forModelArray modelArray : [[EventsModel]]?) {
        if modelArray != nil, modelArray!.count > 0 {
            self.eventsArray = modelArray
            NotificationController().getPendingEventsNotifications(delegate: self)
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.refreshControl = self.refreshControl
                self.tableView.reloadData()
                self.loadingSymbol.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventsArray![section][0].startTime?.monthYearString()
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


