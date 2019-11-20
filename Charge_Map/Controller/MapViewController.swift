//
//  MapViewController.swift
//  Charge_Map
//
//  Created by Macbook pro on 20/11/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var allAnnotations = [MKAnnotation]()
    let apiHelper = API_Helper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        mapView.mapType = .satelliteFlyover
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        getAnnotations()
    }
    
    private func getAnnotations() {
        apiHelper.getAnnotions { (success, result) in
            guard success, let result = result else {
                print("problem")
                return
            }
            
            var annotations = [CustomAnnotation]()
            for annotation in result.records {
                if let latitude = annotation.geometry?.coordinates.last,
                    let longitude = annotation.geometry?.coordinates.first,
                    let access_recharge = annotation.fields?.acces_recharge,
                    let title = annotation.fields?.n_station,
                    let subtitle = annotation.fields?.accessibilite {
                    
                    if access_recharge == "gratuit" || access_recharge == "Gratuit" {
                        let annotation = CustomAnnotation(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), type: .free)
                        annotations.append(annotation)
                    } else {
                        let annotation = CustomAnnotation(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), type: .paid)
                        annotations.append(annotation)
                    }
                }
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(annotations)
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
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
