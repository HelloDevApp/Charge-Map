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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let userLocationManager = CLLocationManager()
    let annotationManager = AnnotationManager()
    let apiHelper = ApiHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        guard let coordinate = coordinatesSelectedAnnotation else { return }
//        mapView.setRegion(MKCoordinateRegion(center: Datas.coordinateUser, latitudinalMeters: 2000, longitudinalMeters: 2000), animated: true)
//        mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000), animated: true)
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
        // if return true the location is enabled, nil position refused, false position not retrived
        let redirection = redirectionIfLocationServiceIsNotAvailable(displayGetAnnotationAction: true)
        if redirection == false {
            let _ = redirectionIfLocationServiceIsNotAvailable(displayGetAnnotationAction: true)
        } else {
            getAnnotations(userPosition: userLocationManager.location?.coordinate ?? nil)
        }
    }
    
    
    private func getAnnotations(userPosition: CLLocationCoordinate2D?) {
        
        let getUserPostition = setupUserLocation()
        
        if getUserPostition.0, let latitude = getUserPostition.1?.latitude, let longitude = getUserPostition.1?.longitude  {
            apiHelper.addGeofilterUrl(latitude: "\(latitude)", longitude: "\(longitude)")
            guard let userCoordinate = getUserPostition.1 else { return }
            Datas.coordinateUser = userCoordinate
            userLocationManager.stopUpdatingLocation()
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
    
    // MARK: - Navigation
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
        }
    }
}


extension MapViewController: CLLocationManagerDelegate {
    
    func checkLocationServiceStatus() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            return true
        } else {
            return false
        }
    }
    
    // nil = get all annotations, false = redirecting to location setting, true = get annotations around user position
    func createAlertAndReturnIfTheLocationIsEnabled() -> (locationIsEnabled: Bool?,alertController: UIAlertController, actions: [UIAlertAction]) {
        var locationIsEnabled: Bool? = false
        // Alert Controller
        let alertController = UIAlertController(title: "Position non detectée", message: "Activer la localisation", preferredStyle: .actionSheet)
        // Alert Action
        let getAnnotationOfCountry = UIAlertAction(title: "Récuperer toutes les bornes", style: .default) { (_) in
            self.getAnnotations(userPosition: nil)
            locationIsEnabled = nil
        }
        // Alert Action
        let redirectingLocationSettings = UIAlertAction(title: "Acceder au réglages", style: .default) { (_) in
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    guard success else { return }
                    if self.checkLocationServiceStatus() == false {
                        locationIsEnabled = false
                    } else {
                        locationIsEnabled = true
                    }
                }
            }
        }
        return (locationIsEnabled, alertController, [getAnnotationOfCountry, redirectingLocationSettings])
    }
    
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
//        guard let locationValue = manager.location?.coordinate else { return }
    }
    
    // pr***
    @objc func appEnterInForeground() {
        if annotationManager.annotations.isEmpty && checkLocationServiceStatus() == true {
            guard let userPosition = userLocationManager.location?.coordinate else { return getAnnotations(userPosition: nil)}
            getAnnotations(userPosition: userPosition)
            print(userPosition)
        } else if annotationManager.annotations.isEmpty && checkLocationServiceStatus() == false {
            let _ = redirectionIfLocationServiceIsNotAvailable(displayGetAnnotationAction: true)
        } else if annotationManager.annotations.isEmpty == false && checkLocationServiceStatus() == false {
            
            let userPositionIsEnabled = redirectionIfLocationServiceIsNotAvailable(displayGetAnnotationAction: false)
            if userPositionIsEnabled == false {
                
                
            }
        }
    }
    
    func redirectionIfLocationServiceIsNotAvailable(displayGetAnnotationAction: Bool) -> Bool? {
        
        guard checkLocationServiceStatus() == false else { return true }
        
        let alertObject = createAlertAndReturnIfTheLocationIsEnabled()
        
        alertObject.alertController.addAction(alertObject.actions[0])
        if displayGetAnnotationAction {
            alertObject.alertController.addAction(alertObject.actions[1])
        } else {
            let cancelAction = UIAlertAction(title: "Retour a la carte", style: .cancel) { (_) in
                alertObject.alertController.dismiss(animated: true, completion: nil)
            }
            alertObject.alertController.addAction(cancelAction)
        }
        
        present(alertObject.alertController, animated: true, completion: nil)
        
        return alertObject.locationIsEnabled
    }

    
}
