import CoreLocation
import MapKit
import UIKit

final class DetailViewController: UIViewController, CLLocationManagerDelegate {
    private let eventTitleLabel = UILabel()
    private let eventDateLabel = UILabel()
    private let eventCategoryLabel = UILabel()
    private let campusMapView = MKMapView()
    private let distanceLabel = UILabel()

    var eventTitleText = "Campus Event"
    var eventDateText = ""
    var eventCategoryText = ""

    private enum CampusLocation {
        static let coordinate = CLLocationCoordinate2D(latitude: 14.6255, longitude: 121.0034)
    }

    private enum LibraryLocation {
        static let coordinate = CLLocationCoordinate2D(latitude: 14.6262, longitude: 121.0038)
    }

    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Events"
        setupUserInterface()

        eventTitleLabel.text = eventTitleText
        eventDateLabel.text = eventDateText
        eventCategoryLabel.text = eventCategoryText
        distanceLabel.text = "Waiting for location permission..."

        configureMap()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManagerDidChangeAuthorization(locationManager)
    }

    private func setupUserInterface() {
        view.backgroundColor = .systemBackground

        let stack = UIStackView(arrangedSubviews: [
            eventTitleLabel,
            eventDateLabel,
            eventCategoryLabel,
            campusMapView,
            distanceLabel
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        eventTitleLabel.textAlignment = .center
        eventTitleLabel.font = .boldSystemFont(ofSize: 23)
        eventTitleLabel.numberOfLines = 0

        eventDateLabel.textAlignment = .center
        eventDateLabel.textColor = .secondaryLabel
        eventDateLabel.font = .systemFont(ofSize: 16)

        eventCategoryLabel.textAlignment = .center
        eventCategoryLabel.textColor = .secondaryLabel
        eventCategoryLabel.font = .systemFont(ofSize: 16)

        distanceLabel.textAlignment = .center
        distanceLabel.numberOfLines = 0
        distanceLabel.font = .boldSystemFont(ofSize: 17)

        campusMapView.translatesAutoresizingMaskIntoConstraints = false
        campusMapView.heightAnchor.constraint(equalToConstant: 260).isActive = true

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func configureMap() {
        let region = MKCoordinateRegion(
            center: CampusLocation.coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        campusMapView.setRegion(region, animated: false)

        let campusAnnotation = MKPointAnnotation()
        campusAnnotation.coordinate = CampusLocation.coordinate
        campusAnnotation.title = "Main Campus"
        campusAnnotation.subtitle = "Campus reference point"

        let libraryAnnotation = MKPointAnnotation()
        libraryAnnotation.coordinate = LibraryLocation.coordinate
        libraryAnnotation.title = "Campus Library"
        libraryAnnotation.subtitle = "Additional campus landmark"

        campusMapView.addAnnotations([campusAnnotation, libraryAnnotation])
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            campusMapView.showsUserLocation = true
            distanceLabel.text = "Finding your current location..."
            manager.requestLocation()
        case .denied, .restricted:
            distanceLabel.text = "Location access denied."
        case .notDetermined:
            distanceLabel.text = "Waiting for location permission..."
        @unknown default:
            distanceLabel.text = "Location status unavailable."
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }

        let campusLocation = CLLocation(
            latitude: CampusLocation.coordinate.latitude,
            longitude: CampusLocation.coordinate.longitude
        )
        let distanceInMeters = currentLocation.distance(from: campusLocation)

        DispatchQueue.main.async {
            self.distanceLabel.text = String(
                format: "You are approximately %.0f meters from campus.",
                distanceInMeters
            )
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        distanceLabel.text = "Could not determine your location."
        print("Location update failed: \(error.localizedDescription)")
    }
}

