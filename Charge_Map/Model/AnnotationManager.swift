//
//  AnnotationManager.swift
//  Charge_Map
//
//  Created by Macbook pro on 22/12/2019.
//  Copyright © 2019 Macbook pro. All rights reserved.
//

import MapKit

class AnnotationManager {

    let datas = Datas()
    
    // array containing the name of the properties of the json returned by the api
    var labelsFieldAfterConvert = [String]()
    
    // array containing the property values of the json returned by the api
    var valuesFieldAfterConvert = [String]()
    
    // table containing all the annotations (OBJECT CLASS) retrieved from the api
    var annotations = [CustomAnnotation]()
    
    // ** CONTAIN ALL ANNOTATIONS INFO RETRIEVE FROM API AFTER REMOVE DUPLICATES **
    var apiAnnotationWithoutDuplicates: [Record?]?
    
    // contains the gps coordinates of the annotation that has been selected
    var coordinatesSelectedAnnotation: CLLocationCoordinate2D?
    
    // contains the selected annotation
    var annotationSelected: CustomAnnotation?
    
    func createAnnotation(annotation: Record) {
        guard let fields = annotation.fields else { return }
        if let latitude = annotation.fields?.coordonnees?.first,
            let longitude = annotation.fields?.coordonnees?.last {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let title = fields.n_station ?? Word.empty
            let subtitle = fields.accessibilite ?? Word.empty
            let paidOrFree: AnnotationType = (fields.acces_recharge == Word.free.capitalized || fields.acces_recharge == Word.free) ? .free : .paid
            let annotation = CustomAnnotation(title: title , subtitle: subtitle, coordinate: coordinate, type: paidOrFree, field: fields)
            annotations.append(annotation)
        }
    }
}

extension AnnotationManager: UrlEncoder {
    
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
