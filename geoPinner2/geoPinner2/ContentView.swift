//
//  ContentView.swift
//  geoPinner2
//
//  Created by Antoine Marandon on 10/07/2022.
//

import SwiftUI
import MapKit
import SwiftCSV

struct ContentView: View, DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        let itemProviders = info.itemProviders(for: [.fileURL])
        guard let itemProvider =  itemProviders.first else {
            print("No item provider")
            return false
        }
        itemProvider.loadObject(ofClass: NSURL.self) { reading, error in
            guard let url = reading as? URL else {
                print("Could not makout what was dropped, \(String(describing: error))")
                return
            }
            do {
                let csv = try NamedCSV(url: url, delimiter: .comma)
                let locations: [Location] = csv.rows.compactMap {
                    guard
                        let latString = $0["Latitude"],
                        let lonString = $0["Longitude"],
                        let lat = Double(latString),
                        let lon = Double(lonString)
                    else {
                        print("Error reading lat/long in \($0)")
                        return nil
                    }
                    return Location(coordinate: .init(latitude: lat, longitude: lon))
                }
                self.locations = locations
            } catch {
                print("Error loading csv: \(error)")
            }
        }
        return true
    }

    struct Location: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    var body: some View {
        Map(coordinateRegion: $coordinateRegion, annotationItems: locations) { location in
            MapMarker(coordinate: location.coordinate)
        }
        .onDrop(of: [.fileURL], delegate: self)
    }

    @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.5, longitude: -0.42), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @State var locations: [Location] = []

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
