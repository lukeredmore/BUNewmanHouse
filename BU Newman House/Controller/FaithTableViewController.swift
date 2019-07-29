//
//  FaithTableViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/25/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

class FaithTableViewController: UITableViewController {
    
    var imageView = UIImageView()
    let imageHeight = 0.4904*UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imageView.frame = CGRect(
//            x: 0,
//            y: -imageHeight,
//            width: UIScreen.main.bounds.size.width,
//            height: imageHeight)
//        imageView.image = UIImage(named: "faithheader")!
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        view.addSubview(imageView)
//        tableView.contentInset.top = imageHeight
//        tableView.reloadData()
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y <= 0 {
//            imageView.frame = CGRect(
//                x: 0,
//                y: -imageHeight,
//                width: UIScreen.main.bounds.size.width,
//                height: -scrollView.contentOffset.y)
//        } else {
//            imageView.frame = CGRect(
//                x: 0,
//                y: 0,
//                width: UIScreen.main.bounds.size.width,
//                height: -scrollView.contentOffset.y)
//        }
        
    }
    
}
