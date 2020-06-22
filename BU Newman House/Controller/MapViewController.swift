//
//  MapViewController.swift
//  BU Newman House
//
//  Created by Luke Redmore on 3/5/19.
//  Copyright © 2019 Newman House of Binghamton University. All rights reserved.
//

import UIKit
import MapKit


///Displays location of selected building in Apple Maps, along with an annotation and optional directions (through Maps app)
class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    let givenLatitude : Double = 42.089240
    let givenLongitude : Double = -75.959830
    
    
    //MARK: View Control
    override func viewWillAppear(_ animated: Bool) {
        let header = "Newman House"
        let initialLocation = CLLocation(latitude: givenLatitude, longitude: givenLongitude)
                centerMapOnLocation(initialLocation)

        let annotation = MapAnnotation(
            title: header,
            discipline: "Sculpture",
            coordinate: initialLocation.coordinate)
        mapView.addAnnotation(annotation)
    }
    
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    
    @IBAction func directionsButtonPressed(_ sender: Any) {
        let urlString = "http://maps.apple.com/?daddr=\(givenLatitude)+\(givenLongitude)&dirflg=d&t=m"
        UIApplication.shared.open(URL(string: urlString)!)
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
