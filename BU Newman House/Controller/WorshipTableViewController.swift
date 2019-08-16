//
//  WorshipTableViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

class WorshipTableViewController: UITableViewController, PendingNotificationDelegate {
    
    let massTimesModel = [
        1: MassDataModel(title: "St. Vincent's - 4:00 PM", id: "vincent1600sat", hour: 16, minute: 00, weekday: 7, tag: 1),
        2: MassDataModel(title: "St. Vincent's - 8:00 AM", id: "vincent0800sun", hour: 8, minute: 00, weekday: 1, tag: 2),
        3: MassDataModel(title: "St. Vincent's - 10:30 AM", id: "vincent1030sun", hour: 10, minute: 30, weekday: 1, tag: 3),
        4: MassDataModel(title: "Newman House - 5:00 PM", id: "newman1700sun", hour: 17, minute: 0, weekday: 1, tag: 4),
        5: MassDataModel(title: "Newman House - 7:00 PM", id: "newman1900sun", hour: 19, minute: 00, weekday: 1, tag: 5)
    ]
    let controller = NotificationController()
    
    @IBOutlet var notificationButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.getPendingEventsNotifications(delegate: self)
    }
    
    @IBAction func notificationButtonToggled(_ sender: UIButton) {
        if let model = massTimesModel[sender.tag] {
            sender.isSelected.toggle()
            if sender.isSelected {
                print("Notifications for event with id \(model.id) have been enabled.")
                controller.addWeeklyNotification(forMassModel: model)
            } else {
                controller.removeNotification(withID: model.id)
            }
        }
    }
    func configureAlerts(forIDList idList: [String]) {
        DispatchQueue.main.async {
            for id in idList {
                for button in self.notificationButton {
                    if id.contains(self.massTimesModel[button.tag]!.id) {
                        button.isSelected = true
                    }
                }
            }
        }
    }
}
