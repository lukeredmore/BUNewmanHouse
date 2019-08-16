//
//  SpiritualityViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 8/16/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit


class SpiritualityViewController: UIViewController, SpiritualityTableViewDelegate {
    
    @IBOutlet weak var loadingSymbol: UIActivityIndicatorView!
    
    func tableViewDidAppear() {
        loadingSymbol.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedSegue" {
            let childVC = segue.destination as! SpiritualityTableViewController
            childVC.delegate = self
        }
    }
    
}

