//
//  AppDelegate.swift
//  geoPinner
//
//  Created by Antoine Marandon on 24/06/2015.
//
//

import Cocoa
import MapKit



class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    init (coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    class ParserDelegate: NSObject, CHCSVParserDelegate {
        var result = [MKAnnotation]()
        private var latitude: CLLocationDegrees?
        private var longitude:  CLLocationDegrees?

        func parser(parser: CHCSVParser!, didFailWithError error: NSError!) {
            println("error parsing csv: \(error)")
        }

        func parser(parser: CHCSVParser!, didBeginLine recordNumber: UInt) {
            latitude = nil
            longitude = nil
        }


        func parser(parser: CHCSVParser!, didEndLine recordNumber: UInt) {
            if let latitude = latitude, longitude = longitude {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                var annotation = Annotation(coordinate: location)
                result.append(annotation)
            }
        }


        func parser(parser: CHCSVParser!, didReadField field: String!, atIndex fieldIndex: Int) {
            if fieldIndex == 2 {
                latitude = CLLocationDegrees((field as NSString).doubleValue)
            } else if fieldIndex == 3 {
                longitude = CLLocationDegrees((field as NSString).doubleValue)
            }
        }

    }

    func application(sender: NSApplication, openFile filename: String) -> Bool {
        let url = NSURL(fileURLWithPath: filename)
        let parser = CHCSVParser(contentsOfCSVURL: url)
        var parserDelegate = ParserDelegate()
        parser.delegate = parserDelegate
        parser.parse()
        let window = (sender.windows.first as! NSWindow)
        let viewController = window.contentViewController as! ViewController
        viewController.mapView.showAnnotations(parserDelegate.result, animated: false)
        return true
    }
}

