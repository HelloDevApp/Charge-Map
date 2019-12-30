//
//  MapViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 20/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, SettingsDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let userLocationManager = CLLocationManager()
    var lastLocation: CLLocationCoordinate2D?
    let annotationManager = AnnotationManager()
    let apiHelper = ApiHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func showSettingViewController(_ sender: UIButton) {
        performSegue(withIdentifier: "mapVCToSettingVC", sender: nil)
    }
    
    @IBAction func showTableView(_ sender: UIButton) {
        guard !annotationManager.annotations.isEmpty else { return }
        performSegue(withIdentifier: Word.mapVCToTableVC, sender: nil)
        
    }
    
    
    // Setup coordinates user, mapView, launch request and display annotations
    private func setupController() {
        let notificationCenter = NotificationCenter.default
               notificationCenter.addObserver(self, selector: #selector(appEnterInForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        mapView.mapType = .hybridFlyover
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
    /*    true = the location is enabled,
          nil = position refused
          false = position not retrived     */
        
        
        
        let locationServiceAuthorization = launchActionsIfLocationServiceIsNotAvailable(controller: self, showGetAllAnnotationsAction: true)
        
        if locationServiceAuthorization == false {
            let _ = launchActionsIfLocationServiceIsNotAvailable(controller: self, showGetAllAnnotationsAction: true)
        } else if locationServiceAuthorization == nil {
            let _ = launchActionsIfLocationServiceIsNotAvailable(controller: self, showGetAllAnnotationsAction: true)
        } else {
            let userPosition = setupUserLocation()
            getAnnotations(userPosition: userPosition.1)
        }
    }
    
    
    func getAnnotations(userPosition: CLLocationCoordinate2D?) {
        
        let getUserPostition = setupUserLocation()
        
        if getUserPostition.0, let latitude = getUserPostition.1?.latitude, let longitude = getUserPostition.1?.longitude  {
            apiHelper.addGeofilterUrl(latitude: "\(latitude)", longitude: "\(longitude)")
            guard let userCoordinate = getUserPostition.1 else { return }
            Datas.coordinateUser = userCoordinate
        }
        
        apiHelper.getAnnotations { (success, result) in
            
            guard success, let result = result else {
                print("problem")
                return
            }
            
            let recordsWithoutDuplicates = self.apiHelper.removeDuplicateRecords(result: result, annotationManager: self.annotationManager)
            
            for annotation in recordsWithoutDuplicates {
                if let annotation = annotation {
                    self.annotationManager.createAnnotation(annotation: annotation)
                }
            }
            
            DispatchQueue.main.async {
                self.mapView.showsUserLocation = true
                self.mapView.addAnnotations(self.annotationManager.annotations)
                let lat = self.annotationManager.datas.setRegionMeters.latitude
                let long = self.annotationManager.datas.setRegionMeters.latitude
                guard let userPosition = userPosition else { return }
                self.mapView.setRegion(MKCoordinateRegion(center: userPosition, latitudinalMeters: lat, longitudinalMeters: long), animated: true)
            }
        }
    }
}
    
// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let cluster = annotation as? MKClusterAnnotation {
            if let firstAnnot = cluster.memberAnnotations.first as? CustomAnnotation {
                return CustomAnnotationView(annotation: firstAnnot, reuseIdentifier: firstAnnot.type.rawValue)
            }
        }
        return mapView.view(for: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let cluster = view.annotation as? MKClusterAnnotation {
            mapView.showAnnotations(cluster.memberAnnotations, animated: true)
        } else {
            guard let annotation = view.annotation as? CustomAnnotation else { return }
            annotationManager.annotationSelected = annotation
            annotationManager.coordinatesSelectedAnnotation = view.annotation?.coordinate
            performSegue(withIdentifier: Word.mapVCToDetailVC, sender: nil)
        }
    }
}

// MARK: - Navigation
extension MapViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Word.mapVCToDetailVC,
            let detailVC = segue.destination as? DetailViewController {
            
            if let annotationSelected = annotationManager.annotationSelected {
                if let fieldAnnotationSelected = annotationSelected.field {
                    detailVC.fields = []
                    detailVC.fields.append(fieldAnnotationSelected)
                    detailVC.apiHelper = apiHelper
                    detailVC.annotationManager = annotationManager
                }
            }
        } else if segue.identifier == Word.mapVCToTableVC, let tableVC = segue.destination as? TableViewController {
            tableVC.annotationManager = annotationManager
        } else if segue.identifier == "mapVCToSettingVC", let settingVC = segue.destination as? SettingViewController {
            
        }
    }
}


extension MapViewController: CLLocationManagerDelegate, AlertActionDelegate, RedirectionDelegate { 
    
    func checkAutorizationStatus(status: CLAuthorizationStatus) {
        switch status {
            case .authorizedAlways: print("ok ")
            case .authorizedWhenInUse: print("ok 2")
            case .denied: print("refused ")
            case .notDetermined: print("not determinated")
            case .restricted: print("autorization resticted")
            @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAutorizationStatus(status: status)
    }
    
    func setupUserLocation() -> (Bool, CLLocationCoordinate2D?) {
        userLocationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            userLocationManager.delegate = self
            userLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            userLocationManager.startUpdatingLocation()
            guard let coordinate = userLocationManager.location?.coordinate else { return (false, nil) }
            return (true, coordinate)
        }
        return (false, nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("coordonnées recuperé")
        print("dernier", locations.last)
        print("premier", locations.first)
        lastLocation = locations.last?.coordinate
        userLocationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    @objc func appEnterInForeground() {
        if annotationManager.annotations.isEmpty && locationServiceIsEnabled() == true {
            let userPosition = setupUserLocation()
            print("userPosition.1", userPosition.1)
            lastLocation = userPosition.1
            print(lastLocation)
            guard let lastUserPosition = lastLocation else { return getAnnotations(userPosition: nil)}
            getAnnotations(userPosition: lastUserPosition)
        } else if annotationManager.annotations.isEmpty && locationServiceIsEnabled() == false {
            let _ = launchActionsIfLocationServiceIsNotAvailable(controller: self, showGetAllAnnotationsAction: true)
        } else if annotationManager.annotations.isEmpty == false && locationServiceIsEnabled() == false {
            let _ = launchActionsIfLocationServiceIsNotAvailable(controller: self, showGetAllAnnotationsAction: false)
        }
    }
}
