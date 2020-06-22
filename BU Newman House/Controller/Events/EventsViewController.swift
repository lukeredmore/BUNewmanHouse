//
//  AboutViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

///Downloads, parses, and displays all the events from Breeze. Alert system controlled by cell itself and NotificationController, not here
class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellSelectionDelegate {
    
    
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
    lazy var eventsRetriever = EventsRetriever(completion: setupTable)
    
    
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
        eventsRetriever.retrieveEventsArray()
    }
    
    
    //MARK: Data Methods
    @objc func refreshData() {
        eventsRetriever.retrieveEventsArray(forceReturn: false, forceRefresh: true)
    }
    
    
    //MARK: TableView Methods
    func setupTable(forModelArray modelArray : [[EventsModel]]?) {
        DispatchQueue.main.async {
        if modelArray != nil, modelArray!.count > 0 {
            self.eventsArray = modelArray
            self.tableView.isHidden = false
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.refreshControl = self.refreshControl
            self.tableView.reloadData()
        } else if (modelArray!.count == 0) {
            self.eventsArray = modelArray
            self.tableView.isHidden = true
        }
        self.loadingSymbol.stopAnimating()
        self.refreshControl.endRefreshing()
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
        cell.addDataForEventsModel(model, selectionDelegate: self)
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont(name: "Gotham-Bold", size: 18)
    }
    func toggleNotificationButtonForEvent(withID id: String) {
        for month in eventsArray.indices {
            for day in eventsArray[month].indices {
                if eventsArray[month][day].id == id {
                    eventsArray[month][day].buttonToggled()
                    tableView.reloadData()
                    eventsRetriever.addObjectArrayToUserDefaults(eventsArray, updateTime: false)
                    break
                }
            }
        }
    }
    
}


