//
//  EventsTableViewCell.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit


class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    
    var model : EventsModel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addDataForEventsModel(_ model : EventsModel) {
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
            notificationButton.isEnabled = true
        } else {
            dayLabel.text = ""
            monthLabel.text = ""
            titleLabel.text = ""
            timeLabel.text = ""
            notificationButton.isEnabled = false
        }
    }
    
    @IBAction func notificationButtonToggled(_ sender: Any) {
        notificationButton.isSelected.toggle()
        if notificationButton.isSelected {
            print("Notifications for event with id \(model.id) have been enabled.")
        } else {
            print("Notifications for event with id \(model.id) have been disabled.")
        }
        //TODO - update UserDefaults, requeue notifications
        
    }
    

}
