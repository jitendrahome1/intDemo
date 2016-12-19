//
//  CurrentLocation.swift
//  Greenply
//
//  Created by Jitendra on 10/17/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import MapKit

class CurrentLocation: NSObject,CLLocationManagerDelegate {
    var successFetching:((latitude: Double, longitude: Double)->())!
    var failureFetching:((message:String)->())!
    var isLocationProvided = false
    let locationManager = CLLocationManager()
    
    static let sharedInstance: CurrentLocation = {
        let obj = CurrentLocation()
        return obj
    }()
    
    override init() {
        super.init()
        
        //mandatory settings to be done
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self;
    }
    
    //Call this method from outside to fetch current location
    func fetchCurrentUserLocation(onSuccess success:(latitude: Double, longitude: Double)->(), failure:(message:String)->()) {
        successFetching = success
        failureFetching = failure
        isLocationProvided = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .Denied: //NotDetermined, .Restricted
                failureFetching(message: LOCATION_DISABLED)
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                break
            }
        } else {
            failureFetching(message: LOCATION_DISABLED)
        }
        
        /*
         if CLLocationManager.locationServicesEnabled() {
         locationManager.startUpdatingLocation()
         }
         else{
         failureFetching(message: LOCATION_DISABLED)
         }
         */
    }
}

extension CurrentLocation {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !isLocationProvided else {
            return
        }
        
        locationManager.stopUpdatingLocation()
        let userLocation:CLLocation = locations.last! // Get the user location in CLLocation object
        successFetching(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        isLocationProvided = true
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        failureFetching(message: LOCATION_FETCH_FAILED)
        
    }

}
