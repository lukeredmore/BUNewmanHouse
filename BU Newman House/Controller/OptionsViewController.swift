//
//  OptionsViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//



import UIKit

class OptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AlertTimePickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var alertList = [Int]()
    let alertTimeOptionsDict = [10080 : "1 week before", 2880 : "2 days before", 1440 : "1 day before", 120 : "2 hours before", 60 : "1 hour before", 30 : "30 minutes before", 15 : "15 minutes before", 5 : "5 minutes before", 0 : "At time of event"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertList = UserDefaults.standard.array(forKey: "eventAlertTimes") as? [Int] ?? [30]
        tableView.backgroundColor = #colorLiteral(red: 0.9253895879, green: 0.9255481362, blue: 0.9253795743, alpha: 1)
        setupTable()
    }
    
    func pickerDidSelectAlertTime(inMinutes time: Int) {
        if !alertList.contains(time) {
            alertList.append(time)
            UserDefaults.standard.set(alertList, forKey: "eventAlertTimes")
            setupTable()
        }
    }
        
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        alertList = alertList.sorted().reversed()
        tableView.reloadData()
    }
    
    //MARK: Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        alertList.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row < alertList.count {
            cell = tableView.dequeueReusableCell(withIdentifier: "alertTimeCell")!
            cell.textLabel?.text = alertTimeOptionsDict[alertList[indexPath.row]]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "addAnotherCell")!
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Calendar Alerts"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == alertList.count {
            let alertTimePickerVC = ModalPickerViewController.instantiate(
                delegate: self)
            self.present(alertTimePickerVC, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < alertList.count {
            if editingStyle == .delete {
                alertList.remove(at: indexPath.row)
                UserDefaults.standard.set(alertList, forKey: "eventAlertTimes")
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
