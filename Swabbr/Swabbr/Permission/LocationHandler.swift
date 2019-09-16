//
//  LocationPermissionHandler.swift
//  Swabbr
//
//  Created by Anonymous on 16-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationHandler : NSObject, PermissionHandlerProtocol {
    
    private static var _self: LocationHandler?
    
    private let locationManager = CLLocationManager()
    
    var hasPermission = false
    
    // init
    required override init() {}
    
    // create static self
    private static func create() {
        if _self == nil {
            _self = self.init()
        }
    }
    
    // ask for permission
    private static func askPermission() {
        
        create()
        
        // check if the device has location functionality
        if CLLocationManager.locationServicesEnabled() {
            
            // check current permission status
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                return
            case .authorizedAlways, .authorizedWhenInUse:
                break
            case .notDetermined:
                // ask for location permissions - always and in use
                _self!.locationManager.requestAlwaysAuthorization()
                _self!.locationManager.requestWhenInUseAuthorization()
            }
            
            _self!.locationManager.delegate = _self!
            _self!.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            _self!.locationManager.startUpdatingLocation()
            _self!.hasPermission = true
        }
    }
    
    
    // create an error dialog window if error permission error occurs
    static func createErrorDialog(rootView: UIViewController) {
        let errorAlert = UIAlertController(title: "Permissions", message: "Location is required", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        rootView.present(errorAlert, animated: true, completion: nil)
    }
    
}

extension LocationHandler : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("test")
    }
}
