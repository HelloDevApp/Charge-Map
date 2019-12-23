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
        let datas = Datas()
        mapView.mapType = .hybridFlyover
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        getAnnotations()
        guard let userPostion = setupUserLocation().1 else { return }
        mapView.setRegion(MKCoordinateRegion(center: userPostion, latitudinalMeters: datas.setRegionMeters.latitude, longitudinalMeters: datas.setRegionMeters.longitude), animated: true)
    }
    
    
    private func getAnnotations() {
        
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
        guard let locationValue = manager.location?.coordinate else { return }
    }
}
