//
//  DetailViewController.swift
//  ProofOfConcert
//
//  Created by Trevor Doodes on 16/03/2017.
//  Copyright © 2017 Ironworks Media Ltd. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var siteIdLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    func configureView() {
        
        if let detail = self.detailItem {
            if let label = self.clientNameLabel {
                label.text = detail.clientName
                self.siteIdLabel.text = detail.siteId
                self.mapView.centerCoordinate = (detail.location)
                let region = MKCoordinateRegionMakeWithDistance(
                    detail.location, 800, 800)
                mapView.setRegion(region, animated: true)
                let newPin = MKPointAnnotation()
                newPin.coordinate = detail.location
                mapView.addAnnotation(newPin)
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Visit? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

