import CoreLocation
import MapKit
import UIKit

final class CampusMapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var distanceLabel: UILabel!

    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Map"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        configureCampusMap()
        locationManager.requestWhenInUseAuthorization()
    }

    private func configureCampusMap() {
        let coordinate = campusLocation.coordinate
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 850,
            longitudinalMeters: 850
        )
        mapView.setRegion(region, animated: false)
        mapView.showsCompass = true

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = AppConfiguration.campusName
        annotation.subtitle = "Campus reference point"
        mapView.addAnnotation(annotation)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            distanceLabel.text = "Finding your current location..."
            mapView.showsUserLocation = true
            manager.requestLocation()
        case .denied:
            distanceLabel.text = "Location access was denied. Enable it in Settings to calculate distance."
        case .restricted:
            distanceLabel.text = "Location access is restricted on this device."
        case .notDetermined:
            distanceLabel.text = "Waiting for location permission..."
        @unknown default:
            distanceLabel.text = "Location status is unavailable."
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let distance = currentLocation.distance(from: campusLocation)

        DispatchQueue.main.async {
            self.distanceLabel.text = String(format: "Distance from campus\n%.0f meters", distance)

            let currentCoordinate = currentLocation.coordinate
            let points = [
                MKMapPoint(self.campusLocation.coordinate),
                MKMapPoint(currentCoordinate)
            ]
            let rect = points.reduce(MKMapRect.null) { partialResult, point in
                partialResult.union(MKMapRect(origin: point, size: MKMapSize(width: 0, height: 0)))
            }
            self.mapView.setVisibleMapRect(
                rect,
                edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 150, right: 40),
                animated: true
            )
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        distanceLabel.text = "Could not determine your location yet."
        print("Location update failed: \(error.localizedDescription)")
    }

    private var campusLocation: CLLocation {
        CLLocation(
            latitude: AppConfiguration.campusCoordinate.latitude,
            longitude: AppConfiguration.campusCoordinate.longitude
        )
    }
}

