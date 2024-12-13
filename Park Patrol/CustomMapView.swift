//
//  CustomMapView.swift
//  Park Patrol
//
//  Created by Daniel Wright & Hector Mojica.
//
//  This file implements a custom map view that integrates MapKit functionality
//  with SwiftUI. It handles user location services, map interactions, and
//  location-based features for the Park Patrol app.

import SwiftUI
import MapKit
import CoreLocation

/// A custom map view component that provides interactive mapping features
/// including user location tracking, pin dropping, and location name lookup
struct CustomMapView: UIViewRepresentable {
    // MARK: - Properties
    
    /// Binding to control the visible region of the map
    @Binding var region: MKCoordinateRegion
    
    /// Binding to store the user-selected location pin
    @Binding var pin: CLLocationCoordinate2D?
    
    /// Binding to store the human-readable name of the selected location
    @Binding var nearestLocation: String
    
    /// Binding to store the formatted coordinate string of the selected location
    @Binding var coordinatesText: String

    // Core location service managers
    /// Manager for handling device location services and authorization
    private let locationManager = CLLocationManager()
    
    /// Service for converting coordinates to human-readable locations
    private let geocoder = CLGeocoder()

    // MARK: - UIViewRepresentable Methods
    
    /// Creates and configures the initial MapKit view
    /// - Parameter context: Context containing the coordinator
    /// - Returns: Configured MKMapView instance
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        // Initialize location services
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Configure tap gesture for pin dropping
        mapView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(context.coordinator.handleTap(_:))
            )
        )

        return mapView
    }

    /// Updates the map view when binding values change
    /// - Parameters:
    ///   - uiView: The MapKit view to update
    ///   - context: Context containing the coordinator
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update visible region
        uiView.setRegion(region, animated: true)
        
        // Refresh annotations
        uiView.removeAnnotations(uiView.annotations)
        
        // Add pin annotation if location is selected
        if let pin = pin {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin
            uiView.addAnnotation(annotation)
        }
    }

    /// Creates the coordinator to handle map interactions
    /// - Returns: Coordinator instance for this view
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator
    /// Coordinator class that handles MapKit delegate methods and user interactions
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        /// Reference to parent view for updating bindings
        var parent: CustomMapView

        /// Initialize coordinator with reference to parent view
        init(_ parent: CustomMapView) {
            self.parent = parent
        }

        /// Updates map when user location changes
        /// - Parameters:
        ///   - manager: Location manager instance
        ///   - locations: Array of user locations, typically using most recent
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                DispatchQueue.main.async {
                    self.parent.region.center = location.coordinate
                }
            }
        }

        /// Handles user taps on the map
        /// - Parameter gestureRecognizer: Tap gesture recognizer instance
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard let mapView = gestureRecognizer.view as? MKMapView else { return }
            
            // Convert screen coordinates to map coordinates
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            // Update pin location and center map
            self.parent.pin = coordinate
            self.parent.region.center = coordinate

            // Lookup location name using reverse geocoding
            let tappedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.parent.geocoder.reverseGeocodeLocation(tappedLocation) { [weak self] placemarks, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    // Update location name and coordinate text
                    if let placemark = placemarks?.first {
                        self.parent.nearestLocation = placemark.name ?? "Unknown Location"
                    } else {
                        self.parent.nearestLocation = "Unknown Location"
                    }
                    self.parent.coordinatesText = "\(coordinate.latitude), \(coordinate.longitude)"
                }
            }
        }
        
        /// Handles changes in location authorization status
        /// - Parameter manager: Location manager instance
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()
            case .denied, .restricted:
                print("Location services denied or restricted")
            case .notDetermined:
                break
            @unknown default:
                break
            }
        }
    }
}
