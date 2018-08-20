//
//  GeoLocationController.swift
//  CoreDataFun
//
//  Created by Anthony Da Cruz on 12/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import CoreLocation


protocol GeoLocationDelegate: class {
    func geoLocationDidChangeAuthorizationStatus(authorized: Bool)
}

class GeoLocation: NSObject {
    
    var isAuthorized: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    
    required init(delegate: GeoLocationDelegate){
        super.init()
        
        self.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            start()
        }
        
    }
    
    func gettingLocation(gotLocation: @escaping (CLLocation?, CLPlacemark?) -> ()){
        guard let location = self.locationManager.location else {
            gotLocation(nil, nil)
            return
        }
        
        //Si on a jamais eu de localisation ou si celle que l'on a est éloigné de 1km + de celle actuelle alors on re-code la localisation 
        guard previousLocation == nil || (previousLocation?.distance(from: location) ?? 0) > 1000 || previousPlacemark == nil else {
            return gotLocation(location, previousPlacemark)
        }
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.previousPlacemark = placemarks?.first
            gotLocation(location, placemarks?.first)
        }
        
    }
    
    
    // MARK: Private
    
    fileprivate weak var delegate: GeoLocationDelegate!
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    fileprivate var geocoder = CLGeocoder()
    fileprivate var previousLocation: CLLocation?
    fileprivate var previousPlacemark: CLPlacemark?
    
    fileprivate func start() {
        delegate.geoLocationDidChangeAuthorizationStatus(authorized: isAuthorized)
        if isAuthorized {
            locationManager.startUpdatingLocation()
        }
    }
    
}

extension GeoLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        start()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
