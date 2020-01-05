//
//  RedirectionDelegate.swift
//  Charge_Map
//
//  Created by Macbook pro on 30/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//
import Foundation
import MapKit

protocol RedirectionDelegate: AlertActionDelegate, UrlEncoder {}

extension RedirectionDelegate {
    
    func locationServiceIsEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            return true
        } else {
            return false
        }
    }
    
    func redirectingToLocationSettings() {
        
        if let url = URL(string: Word.urlSettingsPages) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    func launchActionsIfLocationServiceIsNotAvailable(controller: MapViewController, showGetAllAnnotationsAction: Bool) -> Bool? {
        
        guard locationServiceIsEnabled() == false else { return true }
        
        var locationIsEnabled: Bool? = nil
        
        // get all annotations Action
        let getAllAnnotationsAction = UIAlertAction(title: Word.getAllAnnotationInFrance, style: .default) { (_) in
            controller.getAnnotations(userPosition: nil)
            locationIsEnabled = false
        }
        
         // redirection setting Action
        let redirectingLocationSettingsAction = UIAlertAction(title: "Accèder aux réglages", style: .default) { (_) in
            let _ = self.redirectingToLocationSettings()
        }
        
        // cancel action
        let cancelAction = UIAlertAction(title: "Retour a la carte", style: .cancel) { (_) in
            controller.dismiss(animated: true, completion: nil)
        }
        
        if showGetAllAnnotationsAction {
            presentAlert(controller: controller, title: Word.positionNotDetected, message: Word.activateLocation, actions: [getAllAnnotationsAction, redirectingLocationSettingsAction])
        } else {
            presentAlert(controller: controller, title: Word.positionNotDetected, message: Word.activateLocation, actions: [getAllAnnotationsAction, redirectingLocationSettingsAction, cancelAction])
        }
        
        return locationIsEnabled
    }
    
    func getDirection(destinationCoordinate: CLLocationCoordinate2D) {
        
        let urlBase = createUrlBase(scheme: Word.http, host: Word.hostAppleMap, path: nil)
        
        let parameters: [(key: String, value: String)] =
        [(Word.sourceAdress, "\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)"),
         (Word.destinationAdress , "\(Datas.coordinateUser.latitude),\(Datas.coordinateUser.longitude)"),
         (Word.directionFlg.key, Word.directionFlg.value)]
        
        guard let urlBaseUnwrapped = urlBase else { return }
        let url = encode(urlBase: urlBaseUnwrapped, parameters: parameters)
        
        guard let urlUnwrapped = url else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlUnwrapped, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(urlUnwrapped)
        }
    }
}
