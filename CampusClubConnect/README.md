# Campus Club Connect - MP3

This is a storyboard-based UIKit implementation of the IT0093 Mobile Application Development 2 Machine Problem 3. It includes:

- URLSession GET request and Codable JSON decoding.
- Delete-then-insert synchronization into Core Data.
- PHPickerViewController profile photo selection.
- JPEG persistence in the app's Documents directory.
- CLLocationManager authorization and one-time location updates.
- MapKit campus pin and distance calculation.

## Open the project

1. Open `CampusClubConnect.xcodeproj` in Xcode 15 or newer.
2. Select an iPhone Simulator or a connected iPhone.
3. Run the `CampusClubConnect` scheme.
4. To test the map, choose **Features > Location** in the Simulator and select a location.

## Configure the remote JSON URL

The project includes `CampusClubConnect/clubs.json` as an offline demo fallback. Before submission, publish that same JSON array using a raw GitHub Gist, GitHub file, or another instructor-approved static JSON host. Then replace `remoteClubsURLString` in `CampusClubConnect/AppConfiguration.swift` with the raw HTTPS URL.

The expected JSON shape is:

```json
[
  {
    "name": "Robotics Society",
    "category": "Technology",
    "iconName": "cpu"
  }
]
```

The app attempts the remote request every time the club list appears. If the URL is not configured or the request fails, it loads the bundled JSON so the rest of the app remains demonstrable; the status label identifies that fallback state.

## Main implementation files

- `ClubService.swift` - URLSession request, HTTP validation, and Codable decoding.
- `ClubListViewController.swift` - Core Data replacement and table reload.
- `WelcomeViewController.swift` - PHPicker and Documents-directory photo persistence.
- `CampusMapViewController.swift` - location authorization, map annotation, and distance.
- `PersistenceController.swift` and `ClubConnectModel.xcdatamodeld` - Core Data stack and entity model.

The `Club` entity uses the project’s handwritten `NSManagedObject` files. The model intentionally leaves the entity code-generation attribute unset so Xcode 27 does not try to interpret the older `manual/none` value.

## Reflection

URLSession with Codable plays a role similar to Retrofit with Gson, but the iOS version uses a completion handler and JSONDecoder to move the response into Swift value types. PHPickerViewController provides a system photo-selection flow comparable to Android's Photo Picker while keeping the app's photo access scoped to the selected item. CLLocationManager and MapKit work together like FusedLocationProviderClient and Google Maps, although iOS separates location authorization, one-time updates, and map rendering into different APIs. In both platforms, the important practice is to keep UI work on the main thread and handle permission, network, and decoding errors defensively.

