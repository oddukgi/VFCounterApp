//
//  HomeVC.swift
//  VFCounter
//
//  Created by Sunmi on 2020/07/21.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit
import CoreLocation


class HomeVC: UIViewController {

   let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 0
           
   lazy var headerView: UIView = {
      let subview = UIView()
      subview.backgroundColor = ColorHex.pale
      view.addSubview(subview)
      return subview
    }()
    

    let dateView = DateView()
    let locationManager = CLLocationManager()
    let contentView = UIView()
    let userItemView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
        setContentView()
        settings()
       // locationManager.delegate = self
    }

    // hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func settings() {
        dateView.btnLocation.addTarget(self, action: #selector(retrieveLocation), for: .touchUpInside)
//        dateView.btnPlus.addTarget(self, action: #selector(addItem), for: .touchUpInside)
  
    }
    
    @objc func retrieveLocation() {
         print("Retrieve Button: start tracking Location")
    }
    
    @objc func addItem() {
        print("Plus Button: add item")
        // show itemVC
        
        
    }
}

extension HomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
           print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
           print("user allow app to get location data only when app is active")
        case .denied:
           print("user tap 'disallow' on the permission dialog, can't get location data")
        case .restricted:
           print("parental control setting disallow location data")
        case .notDetermined:
           print("the location permission dialog haven't shown before, user haven't tap allow or disallow")
         default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //. requestLocation will only pass one location to the locations array
        // access it by taking the first element
        
//        if let location = locations.first {
//            print( "Lat, Long: \(location.coordinate.latitude) \(location.coordinate.logitude)")
//            locationManager.stopUpdatingLocation()
//        }
        
        // get recent location data
        for location in locations {
            if location == locations.last {
                print( "Lat, Long: \(location.coordinate.latitude) \(location.coordinate.longitude)")
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    /// 위치서비스가 동작이 않될때
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       // might be that user didn't enable location service on the device
       // or there might be no GPS signal inside a building
        
        print(error.localizedDescription)
    }
}
/*
 let status = CLLocationManager.authorizationStatus()
       
       if (status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()) {
           return
       }
        
       // if haven't show location permission dialog before , show it to user
       if status == .notDetermined {
           locationManager.requestWhenInUseAuthorization()
           
           // if you want to the app to retrieve location data even in background
           // user requestAlwaysAuthorization
           // locationManager.requestAlwaysAuthorization()
           return
       }
       
       // when authorization status is authorized, requestion loation once
       locationManager.requestLocation()
       
       // start monitoring location data and get notified whenever there
       // is change in location data / every few seconds, until stopUpdatingLocation() is called
       locationManager.startUpdatingLocation()
 */
