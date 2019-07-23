//
//  CollectionViewCell.swift
//  CSBC
//
//  Created by Luke Redmore on 7/23/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    

    @IBOutlet var buttonImage: UIImageView!
    @IBOutlet var buttonLabel: UILabel!
    
    func displayContent(image: UIImage, title: String) {
        buttonImage.image = image
        buttonLabel.text = title
    }
    
    
}
