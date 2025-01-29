//
//  LocationManager.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 05/01/2025.
//

import Foundation
import CoreLocation
import FirebaseFirestore

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    private let geoCode = CLGeocoder()
    
    @Published var isPermissionEnabled = false
    
    @Published var location = CLLocation()
    
    @Published var city: String?
    
    @Published var country: String?
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.checkLocationPermission()
    }
    
    private func checkLocationPermission() {
        switch locationManager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Services Enabled")
            break
            
        case .notDetermined, .denied, .restricted:
            self.locationManager.requestWhenInUseAuthorization()
            print("Location Services Not Enabled")
            
        @unknown default:
            self.locationManager.requestWhenInUseAuthorization()
            print("Unknown Error occured fetching Location.")
        }
    }
    
    private func updatePlaceMarks(location: CLLocation) {
        Task { @MainActor in
            do {
                let placemarks = try await geoCode.reverseGeocodeLocation(location)
                
                guard let placemark = placemarks.first else {
                    return
                }
                
                guard let country = placemark.country else {
                    return
                }
                
                guard let city = placemark.locality else {
                    return
                }
                
                self.country = country

                self.city = city
            }
            catch {
                debugPrint("PlaceMark Error: \(error.localizedDescription)")
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        guard let location = manager.location else {
            return
        }
                
        self.location = location

        self.updatePlaceMarks(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        self.updatePlaceMarks(location: location)
                
        self.location = location
    }
}

extension CLLocation {
    
    func toGeoPoint() -> GeoPoint {
        return GeoPoint(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}
