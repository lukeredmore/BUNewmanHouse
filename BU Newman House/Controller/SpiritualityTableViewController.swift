//
//  SpiritualityViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

protocol SpiritualityTableViewDelegate : class {
    func tableViewDidAppear()
}

class SpiritualityTableViewController: UITableViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate : SpiritualityTableViewDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        tableView.backgroundColor = UIColor(named: "superLightGray")
        tableView.tableFooterView = UIView()
        
        SaintOfTheDay.get(completion: setupTable)
            
        
    }
    
    func setupTable(saintName: String, saintDescription: String, imageURLString: String) {
        nameLabel.text = saintName
        descriptionLabel.text = saintDescription
        sizeHeaderToFit()
        tableView.isHidden = false
        delegate?.tableViewDidAppear()
        if let imageURL = URL(string: imageURLString) {
            imageView.downloadAndDisplayImage(fromURL: imageURL)
        }
    }
    
    private func sizeHeaderToFit() {
        if let headerView = tableView.tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()

            let height = nameLabel.frame.height + descriptionLabel.frame.height + imageView.frame.height + 76
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame

            tableView.tableHeaderView = headerView
        }
    }
    
}
