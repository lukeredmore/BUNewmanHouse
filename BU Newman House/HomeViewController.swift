//
//  ViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/23/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let buttonTitles = ["About", "Faith", "Events", "Students", "Parents", "Connect", "Give", "Testimonial"]
    var columnLayout = ColumnFlowLayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: (UIScreen.main.bounds.width)/15.88,
        minimumLineSpacing: (UIScreen.main.bounds.height-133)/15.88,
        sectionInset: UIEdgeInsets(top: 30.0, left: 10.0, bottom: 30.0, right: 10.0)
    )

    @IBOutlet weak var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = columnLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated : Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    //MARK: collectionView Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let image = UIImage(named: /*buttonTitles[indexPath.row]*/ "Contact")
        let title = buttonTitles[indexPath.row]
        cell.displayContent(image: image!, title: title)
        return cell
    }
        
    
    //MARK: Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("\(buttonTitles[indexPath.row]) was selected")
            
    }
    
}

