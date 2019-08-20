//
//  SpiritualityViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit
import SafariServices

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.cellForRow(at: indexPath)?.textLabel?.text {
        case "The Bible":
            presentLinkInSafariView("https://www.biblegateway.com")
        case "USCCB":
            presentLinkInSafariView("http://www.usccb.org")
        case "Pray As You Go":
            presentLinkInSafariView("https://pray-as-you-go.org")
        default:
            break
        }
    }
    
    func presentLinkInSafariView(_ link: String) {
        if let url = URL(string: link) {
            let safariView = SFSafariViewController(url: url)
            safariView.preferredBarTintColor = UIColor(named: "colorPrimaryDark")!
            safariView.preferredControlTintColor = UIColor(named: "systemTextLight")!
            self.present(safariView, animated: true, completion: nil)
        }
    }
    
}
