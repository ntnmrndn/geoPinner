//
//  ViewController.swift
//  geoPinner
//
//  Created by Antoine Marandon on 24/06/2015.
//
//

import Cocoa
import MapKit

class ViewController: NSViewController {
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsCompass = false
        mapView.showsZoomControls = false
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

