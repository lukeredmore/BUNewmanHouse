//
//  AboutContainerViewController.swift
//  CSBC
//
//  Created by Luke Redmore on 3/23/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

///Contains most methods for about page, including table data, delegates, and parallax effect. For some reason, trying to split up these methods results in the table data disappearing after loading
class AboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    var imageView = UIImageView()
    
    let sectionHeaders = ["Map","Contact"]
    let mapImageArray = ["setonMap","saintsMap","saintsMap","jamesMap"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyrightLabel.text = "© " + Date().yearString() + " Newman House of Binghamton University"
        
        let imageHeight = 0.4904*UIScreen.main.bounds.width
        imageView.frame = CGRect(
            x: 0,
            y: 8,
            width: UIScreen.main.bounds.size.width,
            height: imageHeight)
        imageView.image = UIImage(named: "aboutheader")!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        tableView.contentInset.top = imageHeight
        tableView.delegate = self//tableController
        tableView.dataSource = self//tableController
        tableView.reloadData()
    }
    
    
    
    //MARK: TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = [1, 2]
        return sectionArray[section]
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let mapCell = tableView.dequeueReusableCell(withIdentifier: "aboutMapCell") as? AboutMapCell else { return UITableViewCell() }
            mapCell.mapImageView.image = UIImage(named: mapImageArray[0])
            mapCell.buildingLabel.text = "Newman House at Binghamton University"
            mapCell.addressLabel.text = "400 Murray Hill Road Vestal, NY 13850"
            return mapCell
        case 1:
            guard let regularCell = tableView.dequeueReusableCell(withIdentifier: "aboutRegularCell") else { return UITableViewCell() }
            switch indexPath.row {
            case 0:
                regularCell.textLabel?.text = "Phone: 607.798.7202"
                regularCell.imageView?.image = UIImage(named: "phoneicon")
            case 1:
                regularCell.textLabel?.text = "Email: srrose@binghamton.edu"
                regularCell.imageView?.image = UIImage(named: "mailicon")
            default:
                break
            }
            return regularCell
        default:
            return UITableViewCell()
        }
    }
    
    
    //MARK: Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            performSegue(withIdentifier: "showMapSegue", sender: self)
        } else if indexPath == IndexPath(row: 0, section: 1) {
            UIApplication.shared.open(URL(string: "tel://6077987202")!)
        } else if indexPath == IndexPath(row:1, section: 1) {
            AboutMailDelegate(parent: self).presentMailVC()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 0, section: 0) {
            return 112
        } else {
            return UITableView.automaticDimension
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imageView.frame.size.height = -scrollView.contentOffset.y
    }
    
}
