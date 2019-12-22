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
    
    let datas = Datas()
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
//        mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000), animated: true)
//        mapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000), animated: true)
    }
    
    @IBAction func showTableView(_ sender: UIButton) {
        guard !datas.annotations.isEmpty else { return }
        performSegue(withIdentifier: Word.mapVCToTableVC, sender: nil)
        
    }
    
    // Setup coordinates user, mapView, launch request and display annotations
    private func setupController() {
        mapView.mapType = .hybridFlyover
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let coordinateUser = CLLocationCoordinate2D(latitude: 48.0909, longitude: 2.0302)
        mapView.setRegion(MKCoordinateRegion(center: coordinateUser, latitudinalMeters: 90000, longitudinalMeters: 90000), animated: true)
        getAnnotations()
    }
    
    
    private func getAnnotations() {
        apiHelper.getAnnotations { (success, result) in
            
            guard success, let result = result else {
                print("problem")
                return
            }
            
            let recordsWithoutDuplicates = self.apiHelper.removeDuplicateRecords(result: result)
            
            for annotation in recordsWithoutDuplicates {
                if let annotation = annotation {
                    self.createAnnotation(annotation: annotation)
                }
            }
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.datas.annotations)
            }
        }
    }
    
    func createAnnotation(annotation: Record) {
        
        if let latitude = annotation.fields?.coordonnees?.first,
            let longitude = annotation.fields?.coordonnees?.last {
            let fields = annotation.fields
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let paidOrFree: AnnotationType = (fields?.acces_recharge == Word.free.capitalized || fields?.acces_recharge == Word.free) ? .free : .paid
            let annotation = CustomAnnotation(title: fields?.n_station ?? "" , subtitle: "\(fields?.accessibilite ?? "")", coordinate: coordinate, type: paidOrFree, field: fields ?? Fields(type_prise: nil, ad_station: nil, date_maj: nil, accessibilite: nil, n_station: nil, coordonnees: [0.0,0.0], acces_recharge: nil, nbre_pdc: nil, puiss_max: nil))
            datas.annotations.append(annotation)
            
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
        let datas = Datas()
        if let cluster = view.annotation as? MKClusterAnnotation {
            mapView.showAnnotations(cluster.memberAnnotations, animated: true)
            
        } else {
            guard let annotation = view.annotation as? CustomAnnotation else { return }
            
            Datas.annotationSelected = annotation
            datas.coordinatesSelectedAnnotation = view.annotation?.coordinate
            performSegue(withIdentifier: Word.mapVCToDetailVC, sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Word.mapVCToDetailVC,
            let detailVC = segue.destination as? DetailViewController {
            
            if let annotationSelected = Datas.annotationSelected {
                if let fieldAnnotationSelected = annotationSelected.field {
                    detailVC.fields = []
                    detailVC.fields.append(fieldAnnotationSelected)
                    detailVC.apiHelper = apiHelper
                    detailVC.annotationSelected = annotationSelected
                }
            }
        } else if segue.identifier == Word.mapVCToTableVC, let tableVC = segue.destination as? TableViewController {
            tableVC.datas = datas
        }
    }
}
