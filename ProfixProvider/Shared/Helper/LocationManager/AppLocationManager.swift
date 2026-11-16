//
//  AppLocationManager.swift
//  Profix
//
//  Created by Haneen on 31/12/2025.
//


import CoreLocation

final class AppLocationManager: NSObject {
    
    static let shared = AppLocationManager()
    
    private let locationManager = CLLocationManager()
    private var completion: ((AddressModel) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Public API -
    
    func requestLocation(completion: @escaping (AddressModel) -> Void) {
        self.completion = completion
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            sendDefaultLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            sendDefaultLocation()
        }
    }
    
}

extension AppLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
           // sendDefaultLocation()
            break

        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            sendDefaultLocation()
            return
        }
        
        reverseGeocode(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        sendDefaultLocation()
    }
}


extension AppLocationManager {
    
    func sendDefaultLocation() {
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)
        reverseGeocode(defaultCoordinate)
    }
    
    func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {
        AppHelper.getAddressFromCoordinates(latitude: coordinate.latitude,
                                            longitude: coordinate.longitude) { [weak self] address in
            guard let self = self else { return }
            
            let model = AddressModel(
                lat: coordinate.latitude,
                long: coordinate.longitude,
                desc: address
            )
            
            UserDefaults.currentLocation = model

            DispatchQueue.main.async {
                self.completion?(model)
                self.completion = nil
            }
        }
    }
}
