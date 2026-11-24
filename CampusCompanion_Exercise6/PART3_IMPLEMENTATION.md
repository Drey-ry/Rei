# Part 3 Coding Challenge Implemented

## Remove Photo

`ViewController.removePhotoTapped(_:)` deletes `profilePhoto.jpg` from the Documents directory with `FileManager.removeItem(at:)`, restores the `person.crop.circle` placeholder, updates the status message, and disables the Remove Photo button when no image remains.

## Second Campus Landmark

`DetailViewController` declares a named `LibraryLocation.coordinate`, adds a second `MKPointAnnotation` titled `Campus Library`, and keeps the distance calculation tied only to `CampusLocation.coordinate`.
