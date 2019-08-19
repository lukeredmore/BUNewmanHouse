//
//  EventsTableViewCell.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit
protocol TableViewCellSelectionDelegate {
    func toggleNotificationButtonForEvent(withID id: String)
}


class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    
    var model : EventsModel!
    var selectionDelegate : TableViewCellSelectionDelegate? = nil
    
    func addDataForEventsModel(_ model : EventsModel, selectionDelegate : TableViewCellSelectionDelegate) {
        self.selectionDelegate = selectionDelegate
        self.model = model
        titleLabel.text = model.title
        if let start = model.startTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            monthLabel.text = formatter.string(from: start).uppercased()
            formatter.dateFormat = "dd"
            dayLabel.text = formatter.string(from: start)
            formatter.dateFormat = "hh:mm a"
            let startString = formatter.string(from: start)
            if let end = model.endTime {
                let endString = formatter.string(from: end)
                if startString != "12:00 AM" && endString != "12:00 AM" {
                    timeLabel.text = "\(startString) - \(endString)"
                }
            } else if startString != "12:00 AM" {
                timeLabel.text = startString
            } else {
                timeLabel.text = ""
            }
        } else {
            dayLabel.text = ""
            monthLabel.text = ""
            titleLabel.text = ""
            timeLabel.text = ""
        }
        notificationButton.isEnabled = timeLabel.text != ""
        notificationButton.isSelected = model.buttonSelected
    }
    
    @IBAction func notificationButtonToggled(_ sender: Any) {
        selectionDelegate?.toggleNotificationButtonForEvent(withID: model.id)
        notificationButton.isSelected.toggle()
        let controller = NotificationController()
        if notificationButton.isSelected {
            if let startTime = model.startTime {
                print("Notifications for event with id \(model.id) have been enabled.")
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                let titleString = "\(model.title) - \(formatter.string(from: startTime))"
                controller.addNotification(title: titleString, body: "This event begins soon!", date: startTime, id: model.id)
            }
            
        } else {
            controller.removeNotification(withID: model.id)
        }
    }
    

}
