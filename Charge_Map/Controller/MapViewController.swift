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

class MapViewController: UIViewController, SettingsDelegate, AnnotationDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: Properties
    private var coreDataManager: CoreDataManager {
        guard let cdm = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager else { return CoreDataManager() }
        return cdm
    }
    
    var lastLocation: CLLocationCoordinate2D? = nil {
        willSet {
            if newValue != nil {
                getAnnotations(userPosition: newValue, completion: { (success) in
                    guard success else { return }
                    self.updateMapView(with: self.annotationManager.annotations)
                    print("appel fini")
                })
            }
        }
    }
    
    let apiHelper = ApiHelper()
    let annotationManager = AnnotationManager()
    let userLocationManager = CLLocationManager()
    var recordsWithoutDuplicates: [Record?] = []
    // contains the gps coordinates of the annotation that has been selected
    var coordinatesSelectedAnnotation: CLLocationCoordinate2D?
    
    // false = isOff, true = isOn
    var lastValueFreeFilter = false
    var lastValueGetAllAnnotationFilter = false
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lastValueFreeFilter = annotationManager.filterFreeIsOn
        lastValueGetAllAnnotationFilter = annotationManager.filterGetAllAnnotationsIsOn
        addNotificationWillEnterForeground()
        setupController()
        setupUserLocation()
    }
    
    fileprivate func applyFreeFilterOrNotAndUpdate(filterFreeIsOn: Bool) {
        if filterFreeIsOn {
            let filter = self.filterFreeAnnotations(annotations: self.annotationManager.annotations)
            self.updateMapView(with: filter)
        } else {
            self.updateMapView(with: self.annotationManager.annotations)
        }
    }
    
    fileprivate func applyOrRemoveFilterGetAllAnnotations() {
        
        let filterGetAllAnnotations = annotationManager.filterGetAllAnnotationsIsOn
        let filterFreeIsOn = annotationManager.filterFreeIsOn
        
        if filterGetAllAnnotations || filterFreeIsOn, filterGetAllAnnotations != lastValueGetAllAnnotationFilter || filterFreeIsOn != lastValueFreeFilter {
            if filterGetAllAnnotations {
                getAnnotations(userPosition: nil, completion: { (success) in
                    guard success else { return }
                    self.applyFreeFilterOrNotAndUpdate(filterFreeIsOn: filterFreeIsOn)
                })
            } else {
                print(Datas.coordinateUser.longitude, Datas.coordinateUser.latitude)
                
                if Datas.coordinateUser.latitude != 0.0 || Datas.coordinateUser.longitude != 0.0 {
                    getAnnotations(userPosition: Datas.coordinateUser, completion: { (success) in
                        guard success else { return }
                        self.applyFreeFilterOrNotAndUpdate(filterFreeIsOn: filterFreeIsOn)
                    })
                } else {
                    getAnnotations(userPosition: nil, completion: { (success) in
                        guard success else { return }
                        self.applyFreeFilterOrNotAndUpdate(filterFreeIsOn: filterFreeIsOn)
                    })
                }
            }
            
        } else {
            
            if annotationManager.annotations.isEmpty == false,
                (filterFreeIsOn != lastValueFreeFilter || filterGetAllAnnotations != lastValueGetAllAnnotationFilter) &&
                (Datas.coordinateUser.longitude != 0.0 || Datas.coordinateUser.latitude != 0.0) {
                
                getAnnotations(userPosition: Datas.coordinateUser, completion: { (success) in
                    guard success else { return }
                    self.updateMapView(with: self.annotationManager.annotations)
                })
            } else if locationServiceIsEnabled() == false && annotationManager.annotations.isEmpty {
                return
            } else if locationServiceIsEnabled() == false && annotationManager.annotations.isEmpty == false {
                return
            } else if locationServiceIsEnabled() {
                return
            } else {
                getAnnotations(userPosition: nil, completion: { (success) in
                    guard success else { return }
                    self.updateMapView(with: self.annotationManager.annotations)
                })
                
            }
        }
        
        lastValueFreeFilter = annotationManager.filterFreeIsOn
        lastValueGetAllAnnotationFilter = annotationManager.filterGetAllAnnotationsIsOn
        
    }
    
    private func applyOrRemoveFilterFreeAnnotations() {
        
        let filter = filterFreeAnnotations(annotations: annotationManager.annotations)
        
        if annotationManager.filterFreeIsOn {
            if annotationManager.annotations != filter {
                updateMapView(with: filter)
            }
        } else {
            updateMapView(with: annotationManager.annotations)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyOrRemoveFilterGetAllAnnotations()
        refreshImageFavoriteButton()
        applyTheme(theme: Datas.choosenTheme, view: nil, navigationBar: navigationController?.navigationBar, reverse: false)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: @IBActions
    @IBAction func showSettingViewController(_ sender: UIButton) {
        performSegue(withIdentifier: "mapVCToSettingsVC", sender: nil)
    }
    
    @IBAction func showFavoritesView(_ sender: Any) {
        let actions = createActionsToAlert()
        guard locationServiceIsEnabled() else { return presentAlert(controller: self, title: "Position Introuvable", message: "Activer votre position pour acceder a cette fonctionnalité.", actions: [actions[1], actions[2]])}
        guard coreDataManager.read().isEmpty == false else { return }
        performSegue(withIdentifier: "mapVCToFavoriteVC", sender: nil)
    }
    
    @IBAction func showTableView(_ sender: UIButton) {
        guard !annotationManager.annotations.isEmpty else { return }
        performSegue(withIdentifier: Word.mapVCToTableVC, sender: nil)
    }
    
    
    // MARK: Setup & Settings Methods
    // Setup coordinates user, mapView, launch request and display annotations
    fileprivate func addNotificationWillEnterForeground() {
        let notifName = UIApplication.willEnterForegroundNotification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appEnterInForeground), name: notifName, object: nil)
    }
    
    private func setupController() {
        mapView.mapType = .hybridFlyover
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    private func updateMapView(with annotations: [CustomAnnotation]) {
        DispatchQueue.main.async {
            self.mapView.removeAllAnnotations()
            self.mapView.showsUserLocation = true
            self.mapView.addAnnotations(annotations)
            self.mapView.showAllAnnotations()
        }
    }
    
    private func createAllAnnotationsFromRecorsWithoutDuplicates() {
        for annotation in self.recordsWithoutDuplicates {
            if let annotation = annotation {
                let annotationDetail = self.annotationManager.createAnnotation(annotation: annotation)
                guard let annotationDetailUnwrapped = annotationDetail else { return }
                let coordinate = CLLocationCoordinate2D(latitude: annotationDetailUnwrapped.lat, longitude: annotationDetailUnwrapped.long)
                let annotation = CustomAnnotation(title: annotationDetailUnwrapped.title, subtitle: annotationDetailUnwrapped.subtitle, coordinate: coordinate, type: annotationDetailUnwrapped.paidorFree, field: annotationDetailUnwrapped.fields)
                annotationManager.annotations.append(annotation)
            }
        }
    }
    
    private func refreshImageFavoriteButton() {
        if coreDataManager.read().isEmpty {
            favoriteButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "starFilled"), for: .normal)
        }
    }
    
    private func addGeoFilterIfUserPositionIsNotNil(_ userPosition: CLLocationCoordinate2D?) {
        if let userPosition = userPosition {
            apiHelper.addGeofilterUrl(latitude: "\(userPosition.latitude)", longitude: "\(userPosition.longitude)")
        }
    }
    
    // MARK: - Network Call
    func getAnnotations(userPosition: CLLocationCoordinate2D?, completion: @escaping (Bool) -> Void) {
        
        annotationManager.annotations.removeAll()
        mapView.removeAllAnnotations()
        
        addGeoFilterIfUserPositionIsNotNil(userPosition)
        
        apiHelper.getAnnotations { (success, result) in
            
            guard success, let result = result else { return completion(false) }
            
            self.recordsWithoutDuplicates = self.apiHelper.removeDuplicateRecords(result: result, annotationManager: self.annotationManager)
            self.createAllAnnotationsFromRecorsWithoutDuplicates()
            completion(true)
        }
    }
}
    
// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let cluster = annotation as? MKClusterAnnotation {
            if let firstAnnot = cluster.memberAnnotations.first as? CustomAnnotation {
                let customAnnotationView = CustomAnnotationView(annotation: firstAnnot, reuseIdentifier: firstAnnot.type.rawValue)
                customAnnotationView.displayPriority = .required
                return customAnnotationView
            }
        }
        guard let customAnnotation = annotation as? CustomAnnotation else { return mapView.view(for: annotation) }
        let annotationView = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: customAnnotation.type.rawValue)
        annotationView.displayPriority = .required
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let cluster = view.annotation as? MKClusterAnnotation {
            mapView.showAnnotations(cluster.memberAnnotations, animated: true)
        } else {
            guard let annotation = view.annotation as? CustomAnnotation else { return }
            annotationManager.annotationSelected = annotation
            coordinatesSelectedAnnotation = view.annotation?.coordinate
            performSegue(withIdentifier: Word.mapVCToDetailVC, sender: nil)
        }
    }
}

// MARK: - Navigation
extension MapViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        prepareToDetailVC(segue: segue)
        prepareToTableVC(segue: segue)
        prepareToFavoriteVC(segue: segue)
        prepareToSettingsVC(segue: segue)
    }
    
    func prepareToDetailVC(segue: UIStoryboardSegue) {
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
        }
    }
    
    func prepareToTableVC(segue: UIStoryboardSegue) {
        if segue.identifier == Word.mapVCToTableVC, let tableVC = segue.destination as? TableViewController {
            tableVC.annotationManager = annotationManager
        }
    }
    
    func prepareToFavoriteVC(segue: UIStoryboardSegue) {
        if segue.identifier == "mapVCToFavoriteVC", let favoriteTableVC = segue.destination as? FavoriteTableViewController {
            favoriteTableVC.annotationManager = annotationManager
        }
    }
    
    func prepareToSettingsVC(segue: UIStoryboardSegue) {
        if segue.identifier == "mapVCToSettingsVC", let settingsVC = segue.destination as? SettingViewController {
            settingsVC.annotationManager = annotationManager
        }
    }
    
}

// MARK: LocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate, RedirectionDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switchAuthorizationStatusToExecuteAction(status)
    }
    
    private func switchAuthorizationStatusToExecuteAction(_ status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined:
                userLocationManager.requestWhenInUseAuthorization()
            
            case .restricted:
                presentAlertToRestrictedCase()
            
            case .denied:
                presentAlertToDeniedCase()
            
            case .authorizedAlways, .authorizedWhenInUse:
                if annotationManager.annotations.isEmpty && locationServiceIsEnabled() == true {
                    setupUserLocation()
                }
                if annotationManager.annotations.isEmpty == false && locationServiceIsEnabled() == true {
                    return
                }
                userLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                userLocationManager.startUpdatingLocation()
            
            @unknown default:
                break
        }
    }
    
    private func presentAlertToRestrictedCase() {
        if annotationManager.annotations.isEmpty && locationServiceIsEnabled() == false {
            presentAlert(showGetAllAnnotation: true, showCancelAction: false)
        } else if annotationManager.annotations.isEmpty == false && locationServiceIsEnabled() == false {
            presentAlert(showGetAllAnnotation: false, showCancelAction: true)
        }
    }
    
    private func presentAlertToDeniedCase() {
        if annotationManager.annotations.isEmpty {
            presentAlert(showGetAllAnnotation: true, showCancelAction: false)
        } else {
            presentAlert(showGetAllAnnotation: false, showCancelAction: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateCoordinateUserAndStopUpdating(locations)
    }
    
    private func updateCoordinateUserAndStopUpdating(_ locations: [CLLocation]) {
        if let lastCoordinate = locations.first?.coordinate, lastLocation == nil {
            lastLocation = lastCoordinate
            Datas.coordinateUser = lastCoordinate
            userLocationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Impossible de trouver l'emplacement de l'utilisateur: \(error.localizedDescription)")
    }
    
}

// Mark: - Setups and Settings
extension MapViewController {
    
    func setupUserLocation() {
        userLocationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied {
            userLocationManager.requestWhenInUseAuthorization()
            userLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            userLocationManager.startUpdatingLocation()
        } else if CLLocationManager.locationServicesEnabled() == false, CLLocationManager.authorizationStatus() != .denied {
            if annotationManager.annotations.isEmpty == false && locationServiceIsEnabled() == false {
                return
            } else if annotationManager.annotations.isEmpty == false {
                presentAlert(showGetAllAnnotation: false, showCancelAction: true)
            } else {
                presentAlert(showGetAllAnnotation: true, showCancelAction: false)
            }
        } else {
            switchAuthorizationStatusToExecuteAction(CLLocationManager.authorizationStatus())
        }
    }
    
    @objc func appEnterInForeground() {
        switchAuthorizationStatusToExecuteAction(CLLocationManager.authorizationStatus())
    }
    
}


// MARK: - ALERTS Methods
extension MapViewController {
    
    func presentAlert(showGetAllAnnotation: Bool, showCancelAction: Bool) {
        
        let actions = createActionsToAlert()
        var actionsToPresent = [UIAlertAction]()
        
        
        if showGetAllAnnotation {
            actionsToPresent.append(actions[0])
        }
        
        actionsToPresent.append(actions[1])
        
        if showCancelAction {
            actionsToPresent.append(actions[2])
        }
        
        presentAlert(controller: self, title: "Position non detectée", message: "Veuillez activer votre position.", actions: actionsToPresent)
    }
    
    func createActionsToAlert() -> [UIAlertAction] {
        let action1 = UIAlertAction(title: "Récupèrer toutes les annotations", style: .default) { (_) in
            self.getAnnotations(userPosition: nil, completion: { (success) in
                guard success else { return }
                print("action pour alert crée")
                self.updateMapView(with: self.annotationManager.annotations)
            })
        }
        
        let action2 = UIAlertAction(title: "Accéder aux réglages", style: .default) { (_) in
            self.redirectingToLocationSettings()
        }
        
        let action3 = UIAlertAction(title: "Retour à la carte", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        let actions = [action1, action2, action3]
        return actions
    }
}


extension MKMapView {
    
    func showAllAnnotations() {
        self.showAnnotations(self.annotations, animated: true)
    }

    func removeAllAnnotations() {
        self.removeAnnotations(self.annotations)
    }

}
