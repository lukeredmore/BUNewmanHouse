//
//  ViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 7/23/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let buttonTitles = ["About", "Faith", "Events", "Students", "Parents", "Testimonial"]
    
    var columnLayout = ColumnFlowLayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: (UIScreen.main.bounds.width)/15.88,
        minimumLineSpacing: (UIScreen.main.bounds.height-133)/15.88,
        sectionInset: UIEdgeInsets(top: 30.0, left: 10.0, bottom: 100.0, right: 10.0)
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
    
    
    //MARK: CollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        cell.displayContent(
            image: UIImage(named: /*buttonTitles[indexPath.row]*/ "Contact")!,
            title: buttonTitles[indexPath.row]
        )
        return cell
    }
    
    //MARK: Social Media Buttons
    @IBAction func instaButtonPressed(_ sender: Any) {
        let appURL = URL(string: "instagram://user?username=bingnewmanassociation")
        let webURL = URL(string: "https://instagram.com/bingnewmanassociation")
        
        if appURL != nil {
            if UIApplication.shared.canOpenURL(appURL!) {
                UIApplication.shared.open(appURL!)
            } else if webURL != nil {
                UIApplication.shared.open(webURL!)
            }
        } else if webURL != nil {
            UIApplication.shared.open(webURL!)
        }
    }
    @IBAction func facebookButtonPressed(_ sender: Any) {
        let appURL = URL(string: "fb://profile/440796469306479")
        let webURL = URL(string: "https://www.facebook.com/NewmanHouseCatholicChurchAtBinghamtonUniversity/")
        
        if appURL != nil {
            if UIApplication.shared.canOpenURL(appURL!) {
                UIApplication.shared.open(appURL!)
            } else if webURL != nil {
                UIApplication.shared.open(webURL!)
            }
        } else if webURL != nil {
            UIApplication.shared.open(webURL!)
        }
    }
    @IBAction func donateButtonPressed(_ sender: Any) {
        if let webURL = URL(string: "https://newmanbinghamton.weshareonline.org/") {
            let safariView = SFSafariViewController(url: webURL)
            safariView.preferredBarTintColor = UIColor(named: "colorPrimary")!
            safariView.preferredControlTintColor = UIColor(named: "systemTextLight")!
            safariView.modalTransitionStyle = .coverVertical
            safariView.modalPresentationStyle = .overCurrentContext
            present(safariView, animated: true, completion: nil)
        }
    }
    
    
    
    
    //MARK: Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("\(buttonTitles[indexPath.row]) was selected")
        performSegue(withIdentifier: "\(buttonTitles[indexPath.row].lowercased())Segue", sender: self)
        
    }
    
    
    
}

