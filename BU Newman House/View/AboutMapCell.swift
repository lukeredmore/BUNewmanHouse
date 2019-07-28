//
//  AboutMapCell.swift
//  BU Newman House
//
//  Created by Luke Redmore on 3/5/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

class AboutMapCell: UITableViewCell {

    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var buildingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
